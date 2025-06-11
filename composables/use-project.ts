import type { Analysis, Project } from '~/types'
import {
  collection,
  deleteDoc,
  doc,
  getDoc,
  getDocs,
  setDoc,
  updateDoc,
  query,
  where,
  orderBy,
  type CollectionReference,
  type Firestore,
} from 'firebase/firestore'
import { useFirebaseFirestore } from '~/services/firebase.service'

export function useProject() {
  let firestore: Firestore | null = null
  let userId: string | null = null
  let userProjectsCollection: CollectionReference<Project> | null = null

  // Initialize with userId and Firestore instance
  function initialize(uid: string) {
    if (import.meta.client) {
      userId = uid
      firestore = useFirebaseFirestore()
      userProjectsCollection = collection(firestore, 'users', userId, 'projects') as CollectionReference<Project>
    }
  }

  // PROJECTS CRUD

  async function createProject(project: Omit<Project, 'id'>): Promise<Project | undefined> {
    if (!firestore || !userProjectsCollection) {
      console.error('Project service not initialized')
      return
    }
    const ref = doc(userProjectsCollection)
    const payload: Project = { ...project, id: ref.id }
    await setDoc(ref, payload)
    return payload
  }

  async function getProjects(): Promise<Project[]> {
    if (!firestore || !userProjectsCollection) {
      console.error('Project service not initialized')
      return []
    }
    const snap = await getDocs(userProjectsCollection)
    return snap.docs.map((doc) => doc.data())
  }

  async function getProjectById(projectId: string): Promise<Project | null> {
    if (!firestore || !userProjectsCollection || !userId) {
      console.error('Project service not initialized')
      return null
    }
    const ref = doc(firestore, 'users', userId, 'projects', projectId)
    const snap = await getDoc(ref)
    return snap.exists() ? (snap.data() as Project) : null
  }

  async function updateProject(projectId: string, updates: Partial<Project>) {
    if (!firestore || !userProjectsCollection || !userId) {
      console.error('Project service not initialized')
      return
    }
    const ref = doc(firestore, 'users', userId, 'projects', projectId)
    await updateDoc(ref, { ...updates, updatedAt: new Date() })
  }

  async function deleteProject(projectId: string) {
    if (!firestore || !userProjectsCollection || !userId) {
      console.error('Project service not initialized')
      return
    }
    const ref = doc(firestore, 'users', userId, 'projects', projectId)
    await deleteDoc(ref)
  }

  // ANALYSIS SUBCOLLECTION

  function getAnalysisCollection(projectId: string) {
    if (!firestore || !userId) {
      throw new Error('Project service not initialized')
    }
    return collection(firestore, 'users', userId, 'projects', projectId, 'analysis')
  }

  async function addAnalysis(projectId: string, analysis: Analysis) {
    if (!firestore || !userId) {
      console.error('Project service not initialized')
      return
    }
    const analysisCollection = getAnalysisCollection(projectId)
    const ref = doc(analysisCollection)
    await setDoc(ref, analysis)
  }

  async function getAnalysisForProject(projectId: string): Promise<Analysis[]> {
    if (!firestore || !userId) {
      console.error('Project service not initialized')
      return []
    }
    const analysisCollection = getAnalysisCollection(projectId)
    const snap = await getDocs(analysisCollection)
    return snap.docs.map((doc) => doc.data() as Analysis)
  }

  // Get all analysis across all projects for the user
  async function getAllAnalysisForUser(): Promise<{ projectId: string; analysis: Analysis[] }[]> {
    if (!firestore || !userId) {
      console.error('Project service not initialized')
      return []
    }
    if (!userProjectsCollection) {
      throw new Error('User projects collection not initialized')
    }

    const projectsSnap = await getDocs(userProjectsCollection)
    const results = []

    for (const projectDoc of projectsSnap.docs) {
      const projectId = projectDoc.id
      const analysisCollection = getAnalysisCollection(projectId)
      const analysisSnap = await getDocs(analysisCollection)
      results.push({
        projectId,
        analysis: analysisSnap.docs.map((doc) => doc.data() as Analysis),
      })
    }

    return results
  }

  async function deleteAnalysis(projectId: string, analysisId: string) {
    if (!firestore || !userId) {
      console.error('Project service not initialized')
      return
    }
    const analysisRef = doc(firestore, 'users', userId, 'projects', projectId, 'analysis', analysisId)
    await deleteDoc(analysisRef)
  }

  return {
    initialize,
    createProject,
    getProjects,
    getProjectById,
    updateProject,
    deleteProject,
    addAnalysis,
    getAnalysisForProject,
    getAllAnalysisForUser,
    deleteAnalysis,
  }
}
