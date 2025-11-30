FROM mysql:8

# MySQL env
ENV MYSQL_ROOT_PASSWORD=root
ENV MYSQL_DATABASE=trafficdb

# Install Python + pip using microdnf (Oracle Linux)
RUN microdnf install -y python3 python3-pip && \
    microdnf clean all

# Upgrade pip (works normally)
RUN pip3 install --upgrade pip

# Copy requirements and install Python deps
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt

# Copy Python preload script
COPY load_data.py /docker-entrypoint-initdb.d/load_data.py
RUN chmod +x /docker-entrypoint-initdb.d/load_data.py

EXPOSE 3306
