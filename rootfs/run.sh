#!/command/with-contenv bashio

if bashio::config.has_value 'log_level'; then
  bashio::log.level "$(bashio::config 'log_level')"
fi

app_slug="$(bashio::app.slug)"
app_hostname="$(bashio::app.hostname)"
app_port="$(bashio::app.port)"
url_prefix="$(bashio::app.ingress_url)"

recipes_dir="/app_configs/${app_slug}/recipes"

mkdir -p "${recipes_dir}/config"

config=$(bashio::var.json \
  host "${app_hostname}" \
  port "^${app_port}")

if bashio::discovery "${app_slug}" "${config}" > /dev/null; then
  bashio::log.info "Sent discovery information to Home Assistant"
else
  bashio::log.error "Discovery message to Home Assistant failed!"
fi

bashio::log.info "Starting cook server on port ${app_port}"
exec /cook server "${recipes_dir}" --host --port ${app_port} \
  --url-prefix "${url_prefix}" \
  --proxy-strips-prefix \
  --cors-origin "http://${app_hostname}:${app_port}"
