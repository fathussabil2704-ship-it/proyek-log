FROM ubuntu:26.04
RUN useradd -m -u 10001 appuser
WORKDIR /app
COPY src/ /app/src/
RUN chmod +x /app/src/main.sh /app/src/cek-arsip.sh
USER appuser
ENTRYPOINT ["bash", "/app/src/main.sh"]
CMD ["/data/input", "/data/output"]
