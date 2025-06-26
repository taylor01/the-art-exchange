import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "container",
    "artistsToggle", "artistsToggleText", "artistsBadge", "artistsCount",
    "venuesToggle", "venuesToggleText", "venuesBadge", "venuesCount",
    "bandsToggle", "bandsToggleText", "bandsBadge", "bandsCount",
    "yearsToggle", "yearsToggleText", "yearsBadge", "yearsCount",
    "clearSection"
  ]

  connect() {
    this.artistsExpanded = false
    this.venuesExpanded = false
    this.bandsExpanded = false
    this.yearsExpanded = false
    
    // Initialize badge visibility on page load
    setTimeout(() => this.updateBadgeCounts(), 0)
  }

  updateFilters() {
    // Update badge counts
    this.updateBadgeCounts()
    
    // Update clear filters button visibility
    this.updateClearButtonVisibility()
    
    // Trigger search when any filter changes
    const searchController = this.application.getControllerForElementAndIdentifier(
      document.querySelector('[data-controller*="poster-search"]'),
      'poster-search'
    )
    
    if (searchController) {
      // Reset pagination when facet filters change
      searchController.resetPagination()
      searchController.performSearch(false) // false = replace results
    }
  }

  updateBadgeCounts() {
    console.log('updateBadgeCounts called')
    
    // Update Artists badge
    const artistsChecked = this.containerTarget.querySelectorAll('input[name="artists[]"]:checked')
    console.log('Artists checked:', artistsChecked.length)
    this.updateBadge('artists', artistsChecked.length)
    
    // Update Venues badge
    const venuesChecked = this.containerTarget.querySelectorAll('input[name="venues[]"]:checked')
    console.log('Venues checked:', venuesChecked.length)
    this.updateBadge('venues', venuesChecked.length)
    
    // Update Bands badge
    const bandsChecked = this.containerTarget.querySelectorAll('input[name="bands[]"]:checked')
    console.log('Bands checked:', bandsChecked.length)
    this.updateBadge('bands', bandsChecked.length)
    
    // Update Years badge
    const yearsChecked = this.containerTarget.querySelectorAll('input[name="years[]"]:checked')
    console.log('Years checked:', yearsChecked.length)
    this.updateBadge('years', yearsChecked.length)
  }

  updateBadge(category, count) {
    const badgeTarget = `${category}Badge`
    const countTarget = `${category}Count`
    
    console.log(`Updating ${category} badge: count=${count}`)
    
    if (this.hasTarget(badgeTarget) && this.hasTarget(countTarget)) {
      const badge = this[`${badgeTarget}Target`]
      const counter = this[`${countTarget}Target`]
      
      if (count > 0) {
        counter.textContent = count
        badge.style.display = 'inline-flex'
        badge.classList.remove('hidden')
        console.log(`Showing ${category} badge with count ${count}`)
      } else {
        badge.style.display = 'none'
        badge.classList.add('hidden')
        console.log(`Hiding ${category} badge`)
      }
    } else {
      console.log(`Missing targets for ${category}: badge=${this.hasTarget(badgeTarget)}, count=${this.hasTarget(countTarget)}`)
    }
  }

  hasTarget(targetName) {
    return this[`has${targetName.charAt(0).toUpperCase() + targetName.slice(1)}Target`]
  }

  updateClearButtonVisibility() {
    const hasFilters = this.hasActiveFilters()
    
    if (this.hasClearSectionTarget) {
      if (hasFilters) {
        this.clearSectionTarget.classList.remove('hidden')
      } else {
        this.clearSectionTarget.classList.add('hidden')
      }
    }
  }

  hasActiveFilters() {
    // Check if any checkboxes are checked
    const checkboxes = this.containerTarget.querySelectorAll('input[type="checkbox"]:checked')
    if (checkboxes.length > 0) return true
    
    // Check if search query is present
    const queryInput = document.querySelector('[data-poster-search-target="query"]')
    if (queryInput && queryInput.value.trim() !== '') return true
    
    return false
  }

  toggleArtists() {
    this.artistsExpanded = !this.artistsExpanded
    
    if (this.hasArtistsToggleTarget) {
      if (this.artistsExpanded) {
        this.artistsToggleTarget.classList.remove('hidden')
        this.artistsToggleTextTarget.textContent = 'Show less'
      } else {
        this.artistsToggleTarget.classList.add('hidden')
        this.artistsToggleTextTarget.textContent = 'Show more'
      }
    }
  }

  toggleVenues() {
    this.venuesExpanded = !this.venuesExpanded
    
    if (this.hasVenuesToggleTarget) {
      if (this.venuesExpanded) {
        this.venuesToggleTarget.classList.remove('hidden')
        this.venuesToggleTextTarget.textContent = 'Show less'
      } else {
        this.venuesToggleTarget.classList.add('hidden')
        this.venuesToggleTextTarget.textContent = 'Show more'
      }
    }
  }

  toggleBands() {
    this.bandsExpanded = !this.bandsExpanded
    
    if (this.hasBandsToggleTarget) {
      if (this.bandsExpanded) {
        this.bandsToggleTarget.classList.remove('hidden')
        this.bandsToggleTextTarget.textContent = 'Show less'
      } else {
        this.bandsToggleTarget.classList.add('hidden')
        this.bandsToggleTextTarget.textContent = 'Show more'
      }
    }
  }

  toggleYears() {
    this.yearsExpanded = !this.yearsExpanded
    
    if (this.hasYearsToggleTarget) {
      if (this.yearsExpanded) {
        this.yearsToggleTarget.classList.remove('hidden')
        this.yearsToggleTextTarget.textContent = 'Show less'
      } else {
        this.yearsToggleTarget.classList.add('hidden')
        this.yearsToggleTextTarget.textContent = 'Show more'
      }
    }
  }

  clearFilters(event) {
    event.preventDefault()
    
    // Uncheck all filter checkboxes
    const checkboxes = this.containerTarget.querySelectorAll('input[type="checkbox"]')
    checkboxes.forEach(checkbox => {
      checkbox.checked = false
    })

    // Clear search query
    const queryInput = document.querySelector('[data-poster-search-target="query"]')
    if (queryInput) {
      queryInput.value = ''
    }

    // Update badges immediately after clearing
    this.updateBadgeCounts()

    // Trigger search to update results (this will also update clear button visibility)
    this.updateFilters()
  }
}