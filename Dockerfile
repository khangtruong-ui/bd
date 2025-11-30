FROM mysql:8

# MySQL env
ENV MYSQL_ROOT_PASSWORD=root
ENV MYSQL_DATABASE=root

# Install Python and required packages
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    pip3 install --upgrade pip

COPY requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt

# Copy loader script
COPY load_data.py /docker-entrypoint-initdb.d/load_data.py

# Make sure script is executable
RUN chmod +x /docker-entrypoint-initdb.d/load_data.py

# Expose for remote access
EXPOSE 3306
