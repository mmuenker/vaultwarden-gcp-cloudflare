FROM rclone/rclone:1.60.1

RUN apk --update --no-cache add sqlite

COPY crontab /crontab

COPY rclone.conf /rclone.conf

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
