FROM		ubuntu:14.04
MAINTAINER	technopreneural@yahoo.com

# Create volume for data
# NOTE: use "docker run -v <folder_path>:<volume>..." to bind volume to host folder
VOLUME		["/var/lib/mysql/", "/var/log/mysql/"]

# Expose port 3306 (MySQL) to other containers
# NOTE: use "docker run -p 3306:3306..." to map port to host
EXPOSE  	3306

# Enable (or disable) apt-cache proxy
#ENV		http_proxy http://acng.robin.dev:3142

# Pre-seed password into MySQL configuration
RUN		export MYSQL_PASSWORD="root" \
		&& echo "mysql-server-5.5 mysql-server/root_password password ${MYSQL_PASSWORD}" | debconf-set-selections \
		&& echo "mysql-server-5.5 mysql-server/root_password_again password ${MYSQL_PASSWORD}" | debconf-set-selections \

# Install package(s) and delete downloaded data afterwards to reduce image footprint
		&& apt-get update \
		&& DEBIAN_FRONTEND=noninteractive apt-get install -y \
			debconf-utils \
			mysql-server \
#		&& rm -rf /var/lib/apt/lists/* \

# Allow connection from all interfaces
# NOTE: the effect of the line above should be equivalent to that of the line below
#		sed -i "s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
#RUN		sed -i "s/^bind-address/#bind-address/" /etc/mysql/my.cnf \

# Remove warnings
#		&& sed -i '/^\(key_buffer\)\([\w\t]*=\)/s//\1_size\2/' /etc/mysql/my.cnf \
#		&& sed -i '/^\(myisam-recover\)\([\w\t]*=\)/s//\1-options\2/' /etc/mysql/my.cnf \

# Disable autostart
#		&& service mysql stop \
#		&& update-rc.d -f mysql remove

# Run mysql in the foreground when a container is started without a command parameter to execute
#ENTRYPOINT		["/usr/bin/mysqld_safe"]
