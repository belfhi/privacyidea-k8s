{{/*
Expand the name of the chart.
*/}}
{{- define "privacyidea.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "privacyidea.fullname" -}}
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
{{- define "privacyidea.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "privacyidea.labels" -}}
helm.sh/chart: {{ include "privacyidea.chart" . }}
{{ include "privacyidea.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "privacyidea.selectorLabels" -}}
app.kubernetes.io/name: {{ include "privacyidea.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "privacyidea.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "privacyidea.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Create a default fully qualified app name for the postgres requirement.
*/}}
{{- define "privacyidea.postgresql.fullname" -}}
{{- $postgresContext := dict "Values" .Values.postgresql "Release" .Release "Chart" (dict "Name" "postgresql") -}}
{{ include "privacyidea.fullname" .}}-{{ include "postgresql.name" $postgresContext }}
{{- end }}

{{/*
Define the PSQL connection string depending on wether included db is used or not
*/}}
{{- define "privacyidea.sqlstring" -}}
{{- if or .Values.postgresql.enabled  (eq .Values.privacyidea.database.type "postgresql" ) }}
{{- print "postgresql+psychopg2" -}}
{{- else }}
{{- print "mysql+pymysql" -}}
{{- end }}
{{- end }}

{{/*
define DB Secret string
*/}}
{{- define "privacyidea.dbsecret" -}}
{{- if .Values.privacyidea.database.existingSecret }}
{{- .Values.privacyidea.database.existingSecret  }}
{{- else }}
{{- printf "%s-%s" (include  "privacyidea.fullname" .) "dbsecret"  }}
{{- end }}
{{- end}}

{{/* 
define sting for admin username / ps secret
*/}}
{{- define "privacyidea.adminsecret" -}}
{{- if .Values.privacyidea.admin.existingSecret }}
{{- print .Values.privacyidea.admin.existingSecret }}
{{- else }}
{{- printf "%s-%s" (include "privacyidea.fullname" .) "admin-config" }}
{{- end }}
{{- end }}
