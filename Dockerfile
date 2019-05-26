FROM julia:1.1.0-stretch
COPY install-requirements.sh /usr/src/install-requirements.sh
RUN bash -c "chmod +x /usr/src/install-requirements.sh \
              && /usr/src/install-requirements.sh"