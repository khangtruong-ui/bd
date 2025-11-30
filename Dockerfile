###
### STAGE 1 — Build MySQL data directory with preloaded dataset
###
FROM mysql:8 AS builder

ENV MYSQL_ROOT_PASSWORD=rootpass
ENV MYSQL_DATABASE=trafficdb

# Install Python
RUN microdnf install -y python3 python3-pip && microdnf clean all
RUN pip3 install --upgrade pip

# Install Python deps
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt

# Copy Python preload script
COPY load_data.py /tmp/load_data.py

# Initialize MySQL database directory
RUN mkdir -p /var/lib/mysql && \
    chown -R mysql:mysql /var/lib/mysql

# Start MySQL in background (manual startup for build stage)
RUN nohup mysqld --user=mysql --skip-networking --socket=/tmp/mysql.sock & \
    sleep 10 && \
    echo "CREATE DATABASE IF NOT EXISTS trafficdb;" | mysql -uroot --socket=/tmp/mysql.sock

# Run Python script to populate DB
RUN MYSQL_UNIX_PORT=/tmp/mysql.sock python3 /tmp/load_data.py

# Stop MySQL server gracefully
RUN mysqladmin --socket=/tmp/mysql.sock -uroot shutdown

###
### STAGE 2 — Final image that contains the preloaded MySQL data
###
FROM mysql:8

ENV MYSQL_ROOT_PASSWORD=rootpass
ENV MYSQL_DATABASE=trafficdb

# Copy preloaded database from builder stage
COPY --from=builder /var/lib/mysql /var/lib/mysql

EXPOSE 3306
