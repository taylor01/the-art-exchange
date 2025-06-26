import { Controller } from "@hotwired/stimulus"

// Progressive image loading controller for blur-up effect
// Handles smooth transition from blurred placeholder to sharp image
export default class extends Controller {
  static targets = ["placeholder", "mainImage"]
  static values = { 
    placeholderSrc: String,
    mainSrc: String,
    loaded: { type: Boolean, default: false }
  }

  connect() {
    // Set up the progressive loading sequence
    this.setupProgressiveLoading()
  }

  setupProgressiveLoading() {
    // Load placeholder immediately (tiny image, loads fast)
    if (this.hasPlaceholderTarget && this.placeholderSrcValue) {
      this.placeholderTarget.src = this.placeholderSrcValue
      this.placeholderTarget.classList.add("loaded")
    }

    // Start loading main image in background
    if (this.hasMainImageTarget && this.mainSrcValue) {
      this.loadMainImage()
    }
  }

  loadMainImage() {
    const mainImage = this.mainImageTarget
    
    // Create new image to preload
    const img = new Image()
    
    // Set up load handler
    img.onload = () => {
      // Image loaded successfully, show it
      mainImage.src = this.mainSrcValue
      mainImage.classList.remove("loading")
      mainImage.classList.add("loaded")
      
      // Hide placeholder after main image fades in
      setTimeout(() => {
        if (this.hasPlaceholderTarget) {
          this.placeholderTarget.classList.add("hidden")
        }
      }, 300) // Match CSS transition duration
      
      this.loadedValue = true
    }
    
    // Set up error handler
    img.onerror = () => {
      // Failed to load main image, keep placeholder
      console.warn(`Failed to load main image: ${this.mainSrcValue}`)
      if (this.hasPlaceholderTarget) {
        this.placeholderTarget.classList.add("error")
      }
    }
    
    // Start loading
    img.src = this.mainSrcValue
  }

  // Handle intersection observer for lazy loading (optional enhancement)
  observe() {
    if (!this.loadedValue && 'IntersectionObserver' in window) {
      const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            this.setupProgressiveLoading()
            observer.unobserve(entry.target)
          }
        })
      }, {
        rootMargin: '50px' // Start loading 50px before entering viewport
      })
      
      observer.observe(this.element)
    }
  }

  // Force reload if needed
  reload() {
    this.loadedValue = false
    if (this.hasMainImageTarget) {
      this.mainImageTarget.classList.remove("loaded")
      this.mainImageTarget.classList.add("loading")
    }
    if (this.hasPlaceholderTarget) {
      this.placeholderTarget.classList.remove("hidden", "error")
    }
    this.setupProgressiveLoading()
  }
}