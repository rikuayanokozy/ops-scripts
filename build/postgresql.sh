if [ -z $PG_VERSION ]; then
	PG_VERSION=9.6.3
fi
sudo apt update
sudo apt install -y build-essential libreadline-dev zlib1g-dev libxml2-dev python3 libpython3-dev
wget https://ftp.postgresql.org/pub/source/v$PG_VERSION/postgresql-$PG_VERSION.tar.bz2
tar xvf postgresql-$PG_VERSION.tar.bz2
cd postgresql-$PG_VERSION
sudo ln -s python3 /usr/bin/python
CFLAGS='-O3' ./configure --with-libxml --with-python
make world -j16
sudo make install-world
