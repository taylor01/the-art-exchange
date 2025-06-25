import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  connect() {
    this.boundKeyHandler = this.handleKeydown.bind(this)
  }

  disconnect() {
    document.removeEventListener('keydown', this.boundKeyHandler)
  }

  open() {
    if (this.hasModalTarget) {
      this.modalTarget.classList.remove('hidden')
      document.body.style.overflow = 'hidden'
      
      // Add escape key listener
      document.addEventListener('keydown', this.boundKeyHandler)
      
      // Focus first filter input for accessibility
      const firstInput = this.modalTarget.querySelector('input[type="checkbox"]')
      if (firstInput) {
        setTimeout(() => firstInput.focus(), 100)
      }
    }
  }

  close() {
    if (this.hasModalTarget) {
      this.modalTarget.classList.add('hidden')
      document.body.style.overflow = ''
      
      // Remove escape key listener
      document.removeEventListener('keydown', this.boundKeyHandler)
    }
  }

  closeOnBackdrop(event) {
    // Close if clicking on the backdrop (not the modal content)
    if (event.target === event.currentTarget) {
      this.close()
    }
  }

  handleKeydown(event) {
    // Close on escape key
    if (event.key === 'Escape') {
      this.close()
    }
  }
}