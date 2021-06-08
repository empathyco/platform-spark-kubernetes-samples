{{/*
Expand the name of the chart.
*/}}
{{- define "sparkHistoryServer.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "sparkHistoryServer.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "sparkHistoryServer.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "sparkHistoryServer.labels" -}}
helm.sh/chart: {{ include "sparkHistoryServer.chart" . }}
{{- if .Values.team }}
app.kubernetes.io/team: {{ .Values.team | quote }}
{{- end }}
{{- if .Values.project }}
app.kubernetes.io/project: {{ .Values.project | quote }}
{{- end }}
app.kubernetes.io/application: {{ include "sparkHistoryServer.fullname" . | quote }}
{{ include "sparkHistoryServer.selectorLabels" . }}
{{- if .Chart.Version }}
app.kubernetes.io/version: {{ .Chart.Version | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "sparkHistoryServer.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sparkHistoryServer.name" . | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end }}


{{/*
 Name of the role and role binding to use
*/}}
{{- define "sparkHistoryServer.rbacName" -}}
{{- default (include "sparkHistoryServer.fullname" .) .Values.rbac.name }}
{{- end }}



{{/*
Create the name of the spark-hs service account to use
*/}}
{{- define "sparkHistoryServer.serviceAccountName" -}}
{{- if .Values.sparkHistoryServer.serviceAccount.create -}}
    {{ default (include "sparkHistoryServer.fullname" .) .Values.sparkHistoryServer.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.sparkHistoryServer.serviceAccount.name }}
{{- end -}}
{{- end -}}

