{{/*
Expand the name of the chart.
*/}}
{{- define "piwigo.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "piwigo.fullname" -}}
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
{{- define "piwigo.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "piwigo.labels" -}}
helm.sh/chart: {{ include "piwigo.chart" . }}
{{ include "piwigo.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "piwigo.selectorLabels" -}}
app.kubernetes.io/name: {{ include "piwigo.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
MariaDB labels
*/}}
{{- define "piwigo.mariadb.labels" -}}
helm.sh/chart: {{ include "piwigo.chart" . }}
{{ include "piwigo.mariadb.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: database
{{- end }}

{{/*
MariaDB selector labels
*/}}
{{- define "piwigo.mariadb.selectorLabels" -}}
app.kubernetes.io/name: {{ include "piwigo.name" . }}-mariadb
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
MariaDB fullname
*/}}
{{- define "piwigo.mariadb.fullname" -}}
{{- printf "%s-mariadb" (include "piwigo.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
