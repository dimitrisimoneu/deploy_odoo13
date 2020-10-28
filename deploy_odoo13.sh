sudo apt install git python3-pip build-essential wget python3-dev python3-venv python3-wheel libxslt-dev libzip-dev libldap2-dev libsasl2-dev python3-setuptools node-less
sudo useradd -m -d /opt/odoo13 -U -r -s /bin/bash odoo13
sudo apt install postgresql
sudo su - postgres -c "createuser -s odoo13"
wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.bionic_amd64.deb
sudo apt install ./wkhtmltox_0.12.5-1.bionic_amd64.deb
sudo su - odoo13
git clone https://www.github.com/odoo/odoo --depth 1 --branch 13.0 /opt/odoo13/odoo
cd /opt/odoo13
python3 -m venv odoo-venv
source odoo-venv/bin/activate
pip3 install wheel
pip3 install -r odoo/requirements.txt
deactivate
mkdir /opt/odoo13/odoo-custom-addons
exit

echo [options] > /etc/odoo13.conf
echo admin_passwd = Cipsabe10 >>/etc/odoo13.conf
echo db_host = False >>/etc/odoo13.conf
echo db_port = False >>/etc/odoo13.conf
echo db_user = odoo13 >>/etc/odoo13.conf
echo db_password = False >>/etc/odoo13.conf
echo addons_path = /opt/odoo13/odoo/addons,/opt/odoo13/odoo-custom-addons >>/etc/odoo13.conf

echo [Unit] > /etc/systemd/system/odoo13.service
echo Description=Odoo13 >> /etc/systemd/system/odoo13.service
echo Requires=postgresql.service >>  /etc/systemd/system/odoo13.service
echo After=network.target postgresql.service >> /etc/systemd/system/odoo13.service
echo  >> /etc/systemd/system/odoo13.service
echo [Service] >> /etc/systemd/system/odoo13.service
echo Type=simple >> /etc/systemd/system/odoo13.service
echo SyslogIdentifier=odoo13 >> /etc/systemd/system/odoo13.service
echo PermissionsStartOnly=true >> /etc/systemd/system/odoo13.service
echo User=odoo13 >> /etc/systemd/system/odoo13.service
echo Group=odoo13 >> /etc/systemd/system/odoo13.service
echo ExecStart=/opt/odoo13/odoo-venv/bin/python3 /opt/odoo13/odoo/odoo-bin -c /etc/odoo13.conf >> /etc/systemd/system/odoo13.service
echo StandardOutput=journal+console >> /etc/systemd/system/odoo13.service
echo  >> /etc/systemd/system/odoo13.service
echo [Install] >>/etc/systemd/system/odoo13.service
echo WantedBy=multi-user.target >>/etc/systemd/system/odoo13.service

sudo systemctl daemon-reload
sudo systemctl enable --now odoo13
sudo systemctl status odoo13
sudo journalctl -u odoo13
cd /opt/odoo13/odoo-custom-addons
git config --global credential.helper store
