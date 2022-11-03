import { reactive } from 'vue'

export interface Workflow {
  id: string
}

export interface WorkflowStore {
  workflow: Workflow | null
  getWorkflow: () => Promise<void>
}

export const workflowStore: WorkflowStore = reactive({
  workflow: null,
  async getWorkflow () {
    // Call out to graphql
  }
})
