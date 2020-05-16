#!/bin/sh
set -e

# Copy existing custom configuration files
echo "Copy custom configuration files ..."
if [ -d /config ]; then
    cp -R -f "/config/"* /opt/shinobi || echo "No custom config files found." 
else
    echo "Folder /config doesn't exist - not copying custom config files" 
fi

# Create default configurations files from samples if not existing
if [ ! -f /opt/shinobi/conf.json ]; then
    echo "Create default config file /opt/shinobi/conf.json ..."
    cp /opt/shinobi/conf.sample.json /opt/shinobi/conf.json
fi

if [ ! -f /opt/shinobi/super.json ]; then
    echo "Create default config file /opt/shinobi/super.json ..."
    cp /opt/shinobi/super.sample.json /opt/shinobi/super.json
fi

if [ ! -f /opt/shinobi/plugins/motion/conf.json ]; then
    echo "Create default config file /opt/shinobi/plugins/motion/conf.json ..."
    cp /opt/shinobi/plugins/motion/conf.sample.json /opt/shinobi/plugins/motion/conf.json
fi

# Wait for the database to be available
if [ -n "${DATABASE_HOST}" ]; then
    echo "Wait for MySQL server" ...
    while ! mysqladmin ping -h "$DATABASE_HOST" -P $DATABASE_PORT -u "$DATABASE_USER" --password="$DATABASE_PASSWORD"; do
        sleep 1
    done
fi

echo "Setting up MySQL database if it does not exists ..."

echo "Create database schema if it does not exists ..."
mysql -h "$DATABASE_HOST" -P $DATABASE_PORT -u "$DATABASE_USER" --password="$DATABASE_PASSWORD" -e "source /opt/shinobi/sql/framework.sql" || true

echo "Set keys for CRON and PLUGINS from environment variables ..."
sed -i -e 's/"key":"73ffd716-16ab-40f4-8c2e-aecbd3bc1d30"/"key":"'"${CRON_KEY}"'"/g' \
       -e 's/"Motion":"d4b5feb4-8f9c-4b91-bfec-277c641fc5e3"/"Motion":"'"${PLUGINKEY_MOTION}"'"/g' \
       -e 's/"OpenCV":"644bb8aa-8066-44b6-955a-073e6a745c74"/"OpenCV":"'"${PLUGINKEY_OPENCV}"'"/g' \
       -e 's/"OpenALPR":"9973e390-f6cd-44a4-86d7-954df863cea0"/"OpenALPR":"'"${PLUGINKEY_OPENALPR}"'"/g' \
       -e "s/optionally_replace_this_with_db_host/${DATABASE_HOST}/g" \
       -e "s/optionally_replace_this_with_db_user/${DATABASE_USER}/g" \
       -e "s/optionally_replace_this_with_db_password/${DATABASE_PASSWORD}/g" \
       -e "s/optionally_replace_this_with_db_port/${DATABASE_PORT}/g" \
       "/opt/shinobi/conf.json"

# Set the admin password
if [ -n "${ADMIN_USER}" ]; then
    if [ -n "${ADMIN_PASSWORD_MD5}" ]; then
        sed -i -e 's/"mail":"admin@shinobi.video"/"mail":"'"${ADMIN_USER}"'"/g' \
            -e "s/21232f297a57a5a743894a0e4a801fc3/${ADMIN_PASSWORD_MD5}/g" \
            "/opt/shinobi/super.json"
    fi
fi

# Change the uid/gid of the node user
if [ -n "${GID}" ]; then
    if [ -n "${UID}" ]; then
        groupmod -g ${GID} node && usermod -u ${UID} -g ${GID} node
    fi
fi

cd /opt/shinobi
node tools/modifyConfiguration.js cpuUsageMarker=CPU
echo "Getting Latest Shinobi Master ..."
git reset --hard
git pull
npm install
# Execute Command
echo "Starting Shinobi ..."
exec "$@"