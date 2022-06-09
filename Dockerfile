FROM centos:7

RUN yum update
RUN yum install -y git make gcc gcc-c++ openssl-devel readline-devel libcurl-devel libxml2-devel libxslt-devel

ENV INSTALL_PATH /app
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

RUN yum install -y wget patchutils patch
RUN wget https://cache.ruby-lang.org/pub/ruby/1.8/ruby-1.8.7-p374.tar.gz
RUN tar zxvf ruby-1.8.7-p374.tar.gz

RUN cd ruby-1.8.7-p374 && \
 wget -O - "https://github.com/ruby/ruby/commit/0d58bb55985e787364b0235e5e69278d0f0ad4b0.patch" | sed -e '1,/Remove unused variable/d;/test_pkey_ec.rb /,$d'  | patch -p1 && \
 ./configure && make && make install

WORKDIR $INSTALL_PATH
RUN (echo 'gem: --no-document' ; echo 'install: --no-document --no-ri --no-rdoc' ; echo 'update: --no-document --no-ri --no-rdoc') > ~/.gemrc
RUN wget https://rubygems.org/rubygems/rubygems-2.6.12.tgz
RUN tar zxvf rubygems-2.6.12.tgz
RUN cd rubygems-2.6.12 && ruby setup.rb
RUN gem install bundler

RUN rm -rf $INSTALL_PATH
