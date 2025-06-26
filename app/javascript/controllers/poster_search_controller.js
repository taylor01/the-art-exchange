import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "query", "results", "loading", "loadMoreButton"]
  static values = { 
    url: String,
    shareUrl: String
  }

  connect() {
    this.debounceTimeout = null
    this.currentRequest = null
    this.currentPage = 1
    this.isLoadingMore = false
    this.prefetchedResults = null
    this.prefetchedPage = null
    this.hasMoreResults = true
    this.setupInfiniteScroll()
  }

  disconnect() {
    if (this.debounceTimeout) {
      clearTimeout(this.debounceTimeout)
    }
    if (this.currentRequest) {
      this.currentRequest.abort()
    }
    if (this.boundScrollHandler) {
      window.removeEventListener('scroll', this.boundScrollHandler)
    }
  }

  debounceSearch() {
    // Clear any pending search
    if (this.debounceTimeout) {
      clearTimeout(this.debounceTimeout)
    }

    // Debounce the search with 300ms delay
    this.debounceTimeout = setTimeout(() => {
      this.currentPage = 1 // Reset to first page for new search
      this.hasMoreResults = true // Reset for new search
      this.performSearch(false) // false = replace results
    }, 300)
  }

  loadMore() {
    if (this.isLoadingMore) return
    
    this.currentPage += 1
    this.isLoadingMore = true
    this.performSearch(true) // true = append results
  }

  search(event) {
    event.preventDefault()
    this.performSearch()
  }

  // Handle sort dropdown changes
  sortChanged(event) {
    console.log('Sort changed to:', event.target.value)
    // Reset pagination for new sort order
    this.currentPage = 1
    this.hasMoreResults = true
    this.prefetchedResults = null
    this.prefetchedPage = null
    // Perform search with new sort order
    this.performSearch(false) // false = replace results
  }

  async performSearch(append = false, prefetch = false) {
    const formData = new FormData(this.formTarget)
    const searchParams = new URLSearchParams()

    // Add all form data to search params
    for (let [key, value] of formData.entries()) {
      if (value.trim() !== '') {
        searchParams.append(key, value)
      }
    }

    // Add facet filters from checkboxes
    this.addFacetFilters(searchParams)
    
    // Add sort parameter from dropdown (check both desktop and mobile)
    const sortDropdown = document.querySelector('select[name="sort"]:not([id="mobile-sort"])') || 
                         document.querySelector('select[id="mobile-sort"]')
    if (sortDropdown && sortDropdown.value) {
      searchParams.set('sort', sortDropdown.value)
      // Sync the other dropdown
      this.syncSortDropdowns(sortDropdown.value)
    }
    
    // Add pagination
    searchParams.set('page', prefetch ? this.currentPage + 1 : this.currentPage)

    // Show loading state (but not for prefetch)
    if (!prefetch) {
      this.showLoading()
    }

    try {
      // Cancel any ongoing request
      if (this.currentRequest) {
        this.currentRequest.abort()
      }

      // Create new request
      const controller = new AbortController()
      this.currentRequest = controller

      const url = `${this.urlValue}?${searchParams.toString()}`
      const response = await fetch(url, {
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest'
        },
        signal: controller.signal
      })

      if (response.ok) {
        const data = await response.json()
        this.updateResults(data, append, prefetch)
        if (!prefetch) {
          this.updateURL(searchParams)
        }
      } else {
        console.error('Search request failed:', response.status)
      }
    } catch (error) {
      if (error.name !== 'AbortError') {
        console.error('Search error:', error)
      }
    } finally {
      this.hideLoading()
      this.currentRequest = null
    }
  }

  addFacetFilters(searchParams) {
    // Get all checked facet filters
    const facetContainer = document.querySelector('[data-facet-filter-target="container"]')
    if (!facetContainer) return

    const checkboxes = facetContainer.querySelectorAll('input[type="checkbox"]:checked')
    checkboxes.forEach(checkbox => {
      searchParams.append(checkbox.name, checkbox.value)
    })
  }

  updateResults(data, append = false, prefetch = false) {
    if (prefetch) {
      // Store prefetched results for instant display later
      this.prefetchedResults = data.posters
      this.prefetchedPage = this.currentPage + 1
      console.log('Prefetched page', this.prefetchedPage, 'with', data.posters.length, 'posters')
      
      // Check if prefetched page has no results (end of results)
      if (data.posters.length === 0) {
        this.hasMoreResults = false
        console.log('No more results available')
      }
    } else if (append) {
      // Append new results to existing ones
      this.appendResults(data.posters)
      this.isLoadingMore = false
      
      // Check if this page has no results (end of results)
      if (data.posters.length === 0) {
        this.hasMoreResults = false
        console.log('Reached end of results')
      }
    } else {
      // Replace all results (new search)
      this.hasMoreResults = true // Reset for new search
      if (this.hasResultsTarget) {
        const totalCount = data.pagination ? data.pagination.total_count : null
        this.resultsTarget.innerHTML = this.renderPosterGrid(data.posters, totalCount)
      }
      // Start prefetching next page immediately after new search
      if (data.posters.length > 0) {
        setTimeout(() => this.prefetchNextPage(), 100)
      } else {
        this.hasMoreResults = false // No results at all
      }
    }
  }

  renderPosterGrid(posters, totalCount = null) {
    if (posters.length === 0) {
      return this.renderEmptyState()
    }

    const postersHtml = posters.map(poster => this.renderPosterCard(poster)).join('')
    
    const countText = totalCount && totalCount > posters.length 
      ? `Showing ${posters.length} of ${totalCount.toLocaleString()} posters`
      : `Showing ${posters.length} posters`
    
    return `
      <div class="mb-6">
        <p class="text-sm text-stone-600">
          ${countText}
        </p>
      </div>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6 mb-8">
        ${postersHtml}
      </div>
    `
  }

  renderPosterCard(poster) {
    const imageHtml = poster.image_url 
      ? `<img src="${poster.image_url}" class="w-full h-full object-cover" alt="${poster.name}">`
      : `<div class="bg-gradient-to-br from-stone-200 to-stone-300 flex items-center justify-center h-full">
           <div class="text-center text-stone-500">
             <svg class="w-12 h-12 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
               <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
             </svg>
           </div>
         </div>`

    return `
      <div class="bg-white rounded-lg shadow-md hover:shadow-lg transition-shadow duration-200 overflow-hidden" data-testid="poster-card">
        <a href="${poster.url}" class="block">
          <div class="aspect-[3/4]">
            ${imageHtml}
          </div>
          <div class="p-4">
            <h3 class="font-semibold text-stone-900 text-sm mb-1 line-clamp-2">${poster.name}</h3>
            ${poster.band ? `<p class="text-stone-600 text-xs mb-2">${poster.band}</p>` : ''}
            ${poster.venue ? `<p class="text-stone-500 text-xs mb-2">${poster.venue}</p>` : ''}
            <div class="flex items-center justify-between">
              <span class="text-stone-500 text-xs">${poster.year || 'Unknown'}</span>
            </div>
          </div>
        </a>
      </div>
    `
  }

  renderEmptyState() {
    return `
      <div class="text-center py-12">
        <svg class="mx-auto h-12 w-12 text-stone-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.172 16.172a4 4 0 015.656 0M9 12h6m-6-4h6m2 5.291A7.962 7.962 0 0112 15c-2.34 0-4.47-.881-6.08-2.33"></path>
        </svg>
        <h3 class="mt-2 text-sm font-medium text-stone-900">No posters found</h3>
        <p class="mt-1 text-sm text-stone-500">Try adjusting your search or filter criteria.</p>
        <div class="mt-6">
          <a href="${this.urlValue}" class="inline-flex items-center px-4 py-2 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-orange-600 hover:bg-orange-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-orange-500">
            View all posters
          </a>
        </div>
      </div>
    `
  }

  updateURL(searchParams) {
    const newUrl = `${window.location.pathname}?${searchParams.toString()}`
    window.history.pushState({}, '', newUrl)
  }

  showLoading() {
    if (this.hasLoadingTarget) {
      this.loadingTarget.classList.remove('hidden')
    }
    // Don't dim results anymore - just show subtle spinner in search bar
  }

  hideLoading() {
    if (this.hasLoadingTarget) {
      this.loadingTarget.classList.add('hidden')
    }
  }

  async shareSearch() {
    try {
      const formData = new FormData(this.formTarget)
      const searchParams = new URLSearchParams()

      // Add all form data and facet filters
      for (let [key, value] of formData.entries()) {
        if (value.trim() !== '') {
          searchParams.append(key, value)
        }
      }
      this.addFacetFilters(searchParams)
      
      // Add sort parameter
      const sortDropdown = document.querySelector('select[name="sort"]:not([id="mobile-sort"])') || 
                           document.querySelector('select[id="mobile-sort"]')
      if (sortDropdown && sortDropdown.value) {
        searchParams.set('sort', sortDropdown.value)
      }

      const response = await fetch(this.shareUrlValue, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        },
        body: JSON.stringify(Object.fromEntries(searchParams))
      })

      if (response.ok) {
        const data = await response.json()
        
        // Copy to clipboard if available
        if (navigator.clipboard) {
          await navigator.clipboard.writeText(data.url)
          this.showShareNotification('Search URL copied to clipboard!')
        } else {
          // Fallback: show the URL in a prompt
          prompt('Copy this search URL:', data.url)
        }
      } else {
        this.showShareNotification('Failed to create share URL', 'error')
      }
    } catch (error) {
      console.error('Share error:', error)
      this.showShareNotification('Failed to create share URL', 'error')
    }
  }

  showShareNotification(message, type = 'success') {
    // Create a simple notification
    const notification = document.createElement('div')
    notification.className = `fixed top-4 right-4 z-50 px-4 py-2 rounded-lg text-white ${
      type === 'success' ? 'bg-green-500' : 'bg-red-500'
    }`
    notification.textContent = message
    
    document.body.appendChild(notification)
    
    setTimeout(() => {
      notification.remove()
    }, 3000)
  }

  setupInfiniteScroll() {
    this.boundScrollHandler = this.handleScroll.bind(this)
    window.addEventListener('scroll', this.boundScrollHandler)
    
    // Check immediately if page is too short to scroll
    setTimeout(() => {
      this.handleScroll()
    }, 1000)
  }


  handleScroll() {
    if (this.isLoadingMore || !this.hasMoreResults) return

    const scrollTop = window.pageYOffset
    const windowHeight = window.innerHeight
    const docHeight = document.documentElement.scrollHeight
    
    // More aggressive trigger - when user is 500px from bottom OR if there's barely any scroll
    const triggerDistance = Math.min(500, windowHeight * 0.3)
    const nearBottom = scrollTop + windowHeight >= docHeight - triggerDistance
    const shortPage = docHeight - windowHeight < 100 // Page is too short to scroll much
    
    if (nearBottom || shortPage) {
      console.log('Infinite scroll triggered:', { scrollTop, windowHeight, docHeight, shortPage, hasMoreResults: this.hasMoreResults })
      this.loadMoreIfAvailable()
    }
  }

  async loadMoreIfAvailable() {
    console.log('loadMoreIfAvailable called:', {
      prefetchedResults: !!this.prefetchedResults,
      prefetchedPage: this.prefetchedPage,
      currentPage: this.currentPage,
      isLoadingMore: this.isLoadingMore
    })
    
    // If we have prefetched results, show them instantly
    if (this.prefetchedResults && this.prefetchedPage === this.currentPage + 1) {
      console.log('Using prefetched results')
      this.currentPage++
      this.appendResults(this.prefetchedResults)
      this.prefetchedResults = null
      this.prefetchedPage = null
      
      // Start prefetching next page
      this.prefetchNextPage()
    } else if (!this.isLoadingMore) {
      console.log('Loading more normally')
      // No prefetched results, load normally
      this.loadMore()
    } else {
      console.log('Already loading, skipping')
    }
  }

  async prefetchNextPage() {
    try {
      await this.performSearch(false, true) // prefetch next page
    } catch (error) {
      console.log('Prefetch failed:', error)
    }
  }

  appendResults(posters) {
    if (this.hasResultsTarget) {
      const newPostersHtml = this.renderPosterCards(posters)
      this.resultsTarget.insertAdjacentHTML('beforeend', newPostersHtml)
    }
  }

  syncSortDropdowns(value) {
    const desktopSort = document.querySelector('select[name="sort"]:not([id="mobile-sort"])')
    const mobileSort = document.querySelector('select[id="mobile-sort"]')
    
    if (desktopSort && desktopSort.value !== value) {
      desktopSort.value = value
    }
    if (mobileSort && mobileSort.value !== value) {
      mobileSort.value = value
    }
  }

  renderPosterCards(posters) {
    if (posters.length === 0) return ''
    
    const postersHtml = posters.map(poster => this.renderPosterCard(poster)).join('')
    
    return `
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6 mb-8">
        ${postersHtml}
      </div>
    `
  }
}