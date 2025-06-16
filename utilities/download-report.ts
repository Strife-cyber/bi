import type { Project } from "~/types";

export default async function generateReport(projectId: string, analysisIndex: number, projects: Project[]) {
  // Ensure this runs only on client-side
  if (typeof window === 'undefined') return;
  
  const project = projects.find(p => p.id === projectId);
  if (!project) return;
  
  const analysis = project.analysis[analysisIndex];
  if (!analysis) return;
  
  try {
    // Dynamically import html2pdf only on client-side
    const html2pdf = (await import('html2pdf.js')).default;
    
    // Create report container
    const reportContainer = document.createElement('div');
    reportContainer.id = 'pdf-report-container';
    reportContainer.style.width = '210mm';
    reportContainer.style.padding = '20mm';
    reportContainer.style.fontFamily = "'Segoe UI', Tahoma, Geneva, Verdana, sans-serif";
    reportContainer.style.backgroundColor = 'white';
    reportContainer.style.color = '#333';
    reportContainer.style.position = 'fixed';
    reportContainer.style.left = '-9999px'; // Hide off-screen
    
    // Helper functions
    const formatDate = (date: Date) => {
      return new Intl.DateTimeFormat('fr-FR', {
        day: 'numeric',
        month: 'short',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
      }).format(date)
    }

    const calculateDetectionRate = (analysis: any) => {
      if (!analysis.result || analysis.result.length === 0) return 0;
      
      const totalFiles = analysis.result.length;
      const detectedFiles = analysis.result.filter((r: any) => r.valid_detections > 0).length;
      
      return Math.round((detectedFiles / totalFiles) * 100);
    };

    const getMaxSeverity = (analysis: any) => {
      if (!analysis.result) return 'Aucune';
      
      const severities = analysis.result.flatMap((r: any) => 
        Object.keys(r.class_distribution).map(cls => 
          cls === '0' ? 3 : cls === '1' ? 2 : 1
        )
      );
      
      if (severities.length === 0) return 'Aucune';
      
      const maxSeverity = Math.max(...severities);
      return maxSeverity === 3 ? 'Élevée' : maxSeverity === 2 ? 'Moyenne' : 'Faible';
    };

    const getSeverityClass = (classId: string) => {
      return classId === '0' ? 'severity-high' : 
             classId === '1' ? 'severity-medium' : 'severity-low';
    };

    const getClassName = (classId: string) => {
      const classNames: Record<string, string> = {
        '0': 'Fissure Structurelle',
        '1': 'Corrosion Métal',
        '2': 'Déformation',
        '3': 'Dommage Surface'
      };
      return classNames[classId] || `Classe ${classId}`;
    };

    const getClassDistribution = (analysis: any) => {
      const distribution: Record<string, number> = {};
      
      analysis.result?.forEach((result: any) => {
        Object.entries(result.class_distribution).forEach(([cls, count]) => {
          const className = getClassName(cls);
          distribution[className] = (distribution[className] || 0) + Number(count);
        });
      });
      
      return Object.entries(distribution)
        .map(([name, count]) => ({ name, count }))
        .sort((a, b) => b.count - a.count);
    };

    // Build report content
    reportContainer.innerHTML = `
      <style>
        .report-header { text-align: center; margin-bottom: 30px; }
        .report-title { font-size: 28px; font-weight: bold; color: #0e7490; margin-bottom: 5px; }
        .project-name { font-size: 22px; color: #0891b2; margin-bottom: 15px; }
        .analysis-date { font-size: 16px; color: #666; margin-bottom: 25px; }
        .section-title { font-size: 20px; font-weight: bold; color: #0e7490; margin: 25px 0 15px; border-bottom: 2px solid #06b6d4; padding-bottom: 5px; }
        .summary-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; margin-bottom: 30px; }
        .summary-card { background: #f0fdfa; border-radius: 10px; padding: 15px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .summary-title { font-weight: bold; margin-bottom: 10px; color: #0d9488; }
        .summary-value { font-size: 24px; font-weight: bold; color: #0f766e; }
        .summary-label { font-size: 14px; color: #64748b; }
        .detection-table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
        .detection-table th { background-color: #06b6d4; color: white; text-align: left; padding: 12px 15px; }
        .detection-table td { padding: 12px 15px; border-bottom: 1px solid #e2e8f0; }
        .detection-table tr:nth-child(even) { background-color: #f8fafc; }
        .file-preview { width: 80px; height: 80px; object-fit: cover; border-radius: 8px; border: 1px solid #cbd5e1; }
        .severity-indicator { display: inline-block; width: 12px; height: 12px; border-radius: 50%; margin-right: 8px; }
        .severity-high { background-color: #ef4444; }
        .severity-medium { background-color: #f59e0b; }
        .severity-low { background-color: #10b981; }
        .distribution-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 15px; margin-top: 20px; }
        .distribution-card { background: white; border-radius: 8px; padding: 15px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); text-align: center; border: 1px solid #e2e8f0; }
        .distribution-value { font-size: 24px; font-weight: bold; color: #0f766e; margin: 10px 0; }
        .distribution-label { font-size: 14px; color: #64748b; }
        .footer { margin-top: 50px; text-align: center; color: #64748b; font-size: 14px; border-top: 1px solid #e2e8f0; padding-top: 20px; }
      </style>
      
      <div class="report-header">
        <div class="report-title">RAPPORT D'ANALYSE STRUCTURELLE</div>
        <div class="project-name">Projet: ${project.name}</div>
        <div class="analysis-date">${formatDate(new Date())}</div>
      </div>
      
      <div class="summary-grid">
        <div class="summary-card">
          <div class="summary-title">Total des Détections</div>
          <div class="summary-value">${analysis.result?.reduce((sum: number, r: any) => sum + r.valid_detections, 0) || 0}</div>
          <div class="summary-label">Anomalies détectées</div>
        </div>
        <div class="summary-card">
          <div class="summary-title">Fichiers Analysés</div>
          <div class="summary-value">${analysis.files.length}</div>
          <div class="summary-label">Images/Vidéos inspectées</div>
        </div>
        <div class="summary-card">
          <div class="summary-title">Taux de Détection</div>
          <div class="summary-value">${calculateDetectionRate(analysis)}%</div>
          <div class="summary-label">Moyenne sur tous les fichiers</div>
        </div>
        <div class="summary-card">
          <div class="summary-title">Sévérité Maximale</div>
          <div class="summary-value">${getMaxSeverity(analysis)}</div>
          <div class="summary-label">Classification des anomalies</div>
        </div>
      </div>
      
      <div class="section-title">Détails des Détections</div>
      <table class="detection-table">
        <thead>
          <tr>
            <th>Fichier</th>
            <th>Type</th>
            <th>Détections</th>
            <th>Confiance</th>
            <th>Résultats</th>
          </tr>
        </thead>
        <tbody>
          ${analysis.result?.map((result: any, idx: any) => {
            // Create data URL for images to avoid CORS issues in PDF
            const img = new Image();
            img.src = analysis.files[idx] as string;
            const dataUrl = img.src.startsWith('blob:') ? '' : analysis.files[idx];
            
            return `
            <tr>
              <td>
                ${dataUrl ? `<img src="${dataUrl}" class="file-preview" />` : 'Image non disponible'}
              </td>
              <td>${result.type === 'image' ? 'Image' : 'Vidéo'}</td>
              <td>${result.valid_detections}</td>
              <td>${result.confidence_threshold * 100}%</td>
              <td>
                ${Object.entries(result.class_distribution).map(([cls, count]) => `
                  <div>
                    <span class="severity-indicator ${getSeverityClass(cls)}"></span>
                    ${getClassName(cls)}: ${count}
                  </div>
                `).join('') || 'Aucune détection'}
              </td>
            </tr>
          `}).join('') || '<tr><td colspan="5">Aucune donnée disponible</td></tr>'}
        </tbody>
      </table>
      
      <div class="section-title">Distribution des Anomalies</div>
      <div class="distribution-grid">
        ${getClassDistribution(analysis).map(dist => `
          <div class="distribution-card">
            <div class="distribution-value">${dist.count}</div>
            <div class="distribution-label">${dist.name}</div>
          </div>
        `).join('')}
      </div>
      
      <div class="section-title">Visualisation des Résultats</div>
      <div style="display: flex; justify-content: center; margin: 30px 0;">
        <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='400' height='200' viewBox='0 0 400 200'%3E%3Crect x='0' y='0' width='400' height='200' fill='%23f0fdfa'/%3E%3Ctext x='200' y='100' font-family='Arial' font-size='18' fill='%23064748' text-anchor='middle'%3ERésultats Visuels%3C/text%3E%3C/svg%3E" 
            alt="Visualisation graphique" style="width: 100%; max-width: 500px; border-radius: 8px; border: 1px solid #cbd5e1;" />
      </div>
      
      <div class="footer">
        Rapport généré par Bâtiment Intelligent | ${new Date().getFullYear()}
      </div>
    `;
    
    document.body.appendChild(reportContainer);
    
    // Generate PDF
    const options = {
      margin: 10,
      filename: `rapport_${project.name.replace(/\s+/g, '_')}_analyse_${analysisIndex + 1}.pdf`,
      image: { type: 'jpeg', quality: 0.98 },
      html2canvas: { 
        scale: 2, 
        useCORS: true,
        allowTaint: true,
        logging: false
      },
      jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
    };
    
    await html2pdf().set(options).from(reportContainer).save();
    
  } catch (error) {
    console.error('Erreur lors de la génération du PDF:', error);
    alert('Une erreur est survenue lors de la génération du rapport');
  } finally {
    // Clean up
    const container = document.getElementById('pdf-report-container');
    if (container) {
      document.body.removeChild(container);
    }
  }
};