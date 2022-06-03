{{/*
Common labels
*/}}

{{- define "common.labels" -}}
app: {{ .Values.name }}
helm.sh/chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
{{- end -}}