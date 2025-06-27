class JobManager {
  constructor() {
    this.jobs = []
    this.filteredJobs = []
    this.currentEditingId = null
    this.currentDeletingId = null

    this.initializeElements()
    this.bindEvents()
    this.loadJobs()
  }

  initializeElements() {
    // Main elements
    this.jobsGrid = document.getElementById("jobsGrid")
    this.loadingSpinner = document.getElementById("loadingSpinner")
    this.emptyState = document.getElementById("emptyState")

    // Buttons
    this.addJobBtn = document.getElementById("addJobBtn")
    this.refreshBtn = document.getElementById("refreshBtn")

    // Filters
    this.searchInput = document.getElementById("searchInput")
    this.statusFilter = document.getElementById("statusFilter")
    this.typeFilter = document.getElementById("typeFilter")

    // Stats
    this.pendingCount = document.getElementById("pendingCount")
    this.runningCount = document.getElementById("runningCount")
    this.doneCount = document.getElementById("doneCount")
    this.failedCount = document.getElementById("failedCount")

    // Modals
    this.jobModal = document.getElementById("jobModal")
    this.deleteModal = document.getElementById("deleteModal")
    this.modalTitle = document.getElementById("modalTitle")

    // Form elements
    this.jobForm = document.getElementById("jobForm")
    this.jobType = document.getElementById("jobType")
    this.jobStatus = document.getElementById("jobStatus")
    this.jobFiles = document.getElementById("jobFiles")
    this.jobResult = document.getElementById("jobResult")
    this.jobUserId = document.getElementById("jobUserId")
    this.jobProjectId = document.getElementById("jobProjectId")

    // Modal buttons
    this.saveBtn = document.getElementById("saveBtn")
    this.cancelBtn = document.getElementById("cancelBtn")
    this.confirmDeleteBtn = document.getElementById("confirmDeleteBtn")
    this.cancelDeleteBtn = document.getElementById("cancelDeleteBtn")

    // Close buttons
    this.closeButtons = document.querySelectorAll(".close")
  }

  bindEvents() {
    // Button events
    this.addJobBtn.addEventListener("click", () => this.openAddModal())
    this.refreshBtn.addEventListener("click", () => this.loadJobs())

    // Filter events
    this.searchInput.addEventListener("input", () => this.applyFilters())
    this.statusFilter.addEventListener("change", () => this.applyFilters())
    this.typeFilter.addEventListener("change", () => this.applyFilters())

    // Form events
    this.jobForm.addEventListener("submit", (e) => this.handleFormSubmit(e))
    this.cancelBtn.addEventListener("click", () => this.closeModal())

    // Delete modal events
    this.confirmDeleteBtn.addEventListener("click", () => this.confirmDelete())
    this.cancelDeleteBtn.addEventListener("click", () => this.closeDeleteModal())

    // Close modal events
    this.closeButtons.forEach((btn) => {
      btn.addEventListener("click", (e) => {
        const modal = e.target.closest(".modal")
        modal.style.display = "none"
      })
    })

    // Click outside modal to close
    window.addEventListener("click", (e) => {
      if (e.target.classList.contains("modal")) {
        e.target.style.display = "none"
      }
    })
  }

  async loadJobs() {
    try {
      this.showLoading()
      const response = await fetch("/api/jobs")
      if (!response.ok) throw new Error("Failed to load jobs")

      this.jobs = await response.json()
      this.filteredJobs = [...this.jobs]
      this.updateStats()
      this.renderJobs()
      this.hideLoading()
    } catch (error) {
      console.error("Error loading jobs:", error)
      this.showError("Failed to load jobs")
      this.hideLoading()
    }
  }

  showLoading() {
    this.loadingSpinner.style.display = "block"
    this.jobsGrid.style.display = "none"
    this.emptyState.style.display = "none"
  }

  hideLoading() {
    this.loadingSpinner.style.display = "none"
    this.jobsGrid.style.display = "grid"
  }

  updateStats() {
    const stats = this.jobs.reduce((acc, job) => {
      acc[job.status] = (acc[job.status] || 0) + 1
      return acc
    }, {})

    this.pendingCount.textContent = stats.pending || 0
    this.runningCount.textContent = stats.running || 0
    this.doneCount.textContent = stats.done || 0
    this.failedCount.textContent = stats.failed || 0
  }

  applyFilters() {
    const searchTerm = this.searchInput.value.toLowerCase()
    const statusFilter = this.statusFilter.value
    const typeFilter = this.typeFilter.value

    this.filteredJobs = this.jobs.filter((job) => {
      const matchesSearch =
        !searchTerm ||
        job.id.toLowerCase().includes(searchTerm) ||
        job.type.toLowerCase().includes(searchTerm) ||
        job.data.userId.toLowerCase().includes(searchTerm) ||
        job.data.projectId.toLowerCase().includes(searchTerm)

      const matchesStatus = !statusFilter || job.status === statusFilter
      const matchesType = !typeFilter || job.type === typeFilter

      return matchesSearch && matchesStatus && matchesType
    })

    this.renderJobs()
  }

  renderJobs() {
    if (this.filteredJobs.length === 0) {
      this.jobsGrid.style.display = "none"
      this.emptyState.style.display = "block"
      return
    }

    this.emptyState.style.display = "none"
    this.jobsGrid.style.display = "grid"

    this.jobsGrid.innerHTML = this.filteredJobs.map((job) => this.createJobCard(job)).join("")

    // Bind action buttons
    this.bindJobActions()
  }

  createJobCard(job) {
    const files = JSON.parse(job.data.files || "[]")
    const createdAt = new Date(job.data.createdAt).toLocaleDateString()
    const completedAt = job.completedAt ? new Date(job.completedAt).toLocaleDateString() : "N/A"

    return `
            <div class="job-card status-${job.status}">
                <div class="job-header">
                    <div>
                        <div class="job-title">${job.type}</div>
                        <div class="job-id">${job.id}</div>
                    </div>
                    <span class="job-status ${job.status}">${job.status}</span>
                </div>
                
                <div class="job-details">
                    <div class="job-detail">
                        <strong>User ID:</strong>
                        <span>${job.data.userId || "N/A"}</span>
                    </div>
                    <div class="job-detail">
                        <strong>Project ID:</strong>
                        <span>${job.data.projectId || "N/A"}</span>
                    </div>
                    <div class="job-detail">
                        <strong>Created:</strong>
                        <span>${createdAt}</span>
                    </div>
                    <div class="job-detail">
                        <strong>Completed:</strong>
                        <span>${completedAt}</span>
                    </div>
                </div>

                ${
                  files.length > 0
                    ? `
                    <div class="job-files">
                        <h4><i class="fas fa-paperclip"></i> Files (${files.length})</h4>
                        <div class="file-list">
                            ${files
                              .slice(0, 3)
                              .map(
                                (file) => `
                                <a href="${file}" target="_blank" class="file-item">
                                    <i class="fas fa-external-link-alt"></i>
                                    ${this.getFileName(file)}
                                </a>
                            `,
                              )
                              .join("")}
                            ${files.length > 3 ? `<span class="file-item">+${files.length - 3} more</span>` : ""}
                        </div>
                    </div>
                `
                    : ""
                }

                <div class="job-actions">
                    <button class="btn btn-secondary btn-small edit-job" data-id="${job.id}">
                        <i class="fas fa-edit"></i> Edit
                    </button>
                    <button class="btn btn-danger btn-small delete-job" data-id="${job.id}">
                        <i class="fas fa-trash"></i> Delete
                    </button>
                </div>
            </div>
        `
  }

  getFileName(url) {
    try {
      const urlObj = new URL(url)
      const pathname = urlObj.pathname
      const filename = pathname.split("/").pop()
      return filename.length > 15 ? filename.substring(0, 15) + "..." : filename
    } catch {
      return "File"
    }
  }

  bindJobActions() {
    // Edit buttons
    document.querySelectorAll(".edit-job").forEach((btn) => {
      btn.addEventListener("click", (e) => {
        const jobId = e.target.closest(".edit-job").dataset.id
        this.openEditModal(jobId)
      })
    })

    // Delete buttons
    document.querySelectorAll(".delete-job").forEach((btn) => {
      btn.addEventListener("click", (e) => {
        const jobId = e.target.closest(".delete-job").dataset.id
        this.openDeleteModal(jobId)
      })
    })
  }

  openAddModal() {
    this.currentEditingId = null
    this.modalTitle.textContent = "Add New Job"
    this.saveBtn.textContent = "Create Job"
    this.resetForm()
    this.jobModal.style.display = "block"
  }

  openEditModal(jobId) {
    const job = this.jobs.find((j) => j.id === jobId)
    if (!job) return

    this.currentEditingId = jobId
    this.modalTitle.textContent = "Edit Job"
    this.saveBtn.textContent = "Update Job"

    // Populate form
    this.jobType.value = job.type
    this.jobStatus.value = job.status
    this.jobFiles.value = job.data.files
    this.jobResult.value = JSON.stringify(job.data.result, null, 2)
    this.jobUserId.value = job.data.userId
    this.jobProjectId.value = job.data.projectId

    this.jobModal.style.display = "block"
  }

  openDeleteModal(jobId) {
    this.currentDeletingId = jobId
    this.deleteModal.style.display = "block"
  }

  closeModal() {
    this.jobModal.style.display = "none"
    this.resetForm()
  }

  closeDeleteModal() {
    this.deleteModal.style.display = "none"
    this.currentDeletingId = null
  }

  resetForm() {
    this.jobForm.reset()
    this.jobFiles.value = "[]"
    this.jobResult.value = "{}"
  }

  async handleFormSubmit(e) {
    e.preventDefault()

    try {
      // Validate JSON fields
      let files, result
      try {
        files = this.jobFiles.value.trim() || "[]"
        JSON.parse(files)
      } catch {
        throw new Error("Files must be valid JSON array")
      }

      try {
        result = JSON.parse(this.jobResult.value.trim() || "{}")
      } catch {
        throw new Error("Result must be valid JSON")
      }

      const jobData = {
        type: this.jobType.value,
        status: this.jobStatus.value,
        files: files,
        result: result,
        userId: this.jobUserId.value.trim(),
        projectId: this.jobProjectId.value.trim(),
      }

      this.saveBtn.disabled = true
      this.saveBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...'

      let response
      if (this.currentEditingId) {
        response = await fetch(`/api/jobs/${this.currentEditingId}`, {
          method: "PUT",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(jobData),
        })
      } else {
        response = await fetch("/api/jobs", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(jobData),
        })
      }

      if (!response.ok) {
        const error = await response.json()
        throw new Error(error.error || "Failed to save job")
      }

      this.closeModal()
      await this.loadJobs()
      this.showSuccess(this.currentEditingId ? "Job updated successfully!" : "Job created successfully!")
    } catch (error) {
      console.error("Error saving job:", error)
      this.showError(error.message)
    } finally {
      this.saveBtn.disabled = false
      this.saveBtn.innerHTML = this.currentEditingId ? "Update Job" : "Create Job"
    }
  }

  async confirmDelete() {
    if (!this.currentDeletingId) return

    try {
      this.confirmDeleteBtn.disabled = true
      this.confirmDeleteBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Deleting...'

      const response = await fetch(`/api/jobs/${this.currentDeletingId}`, {
        method: "DELETE",
      })

      if (!response.ok) {
        const error = await response.json()
        throw new Error(error.error || "Failed to delete job")
      }

      this.closeDeleteModal()
      await this.loadJobs()
      this.showSuccess("Job deleted successfully!")
    } catch (error) {
      console.error("Error deleting job:", error)
      this.showError(error.message)
    } finally {
      this.confirmDeleteBtn.disabled = false
      this.confirmDeleteBtn.innerHTML = "Delete"
    }
  }

  showSuccess(message) {
    // Simple success notification - you can enhance this
    const notification = document.createElement("div")
    notification.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: #10b981;
            color: white;
            padding: 15px 20px;
            border-radius: 8px;
            z-index: 10000;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        `
    notification.textContent = message
    document.body.appendChild(notification)

    setTimeout(() => {
      notification.remove()
    }, 3000)
  }

  showError(message) {
    // Simple error notification - you can enhance this
    const notification = document.createElement("div")
    notification.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: #ef4444;
            color: white;
            padding: 15px 20px;
            border-radius: 8px;
            z-index: 10000;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        `
    notification.textContent = message
    document.body.appendChild(notification)

    setTimeout(() => {
      notification.remove()
    }, 5000)
  }
}

// Initialize the job manager when DOM is loaded
document.addEventListener("DOMContentLoaded", () => {
  new JobManager()
})
