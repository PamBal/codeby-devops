
# Rsync configuration

## Режим работы

Rsync over SSH (без rsync daemon).

- Source VM: server (192.168.56.30)
- Destination VM: store (192.168.56.31)
- Source directory: /opt/mysql_backup/
- Destination directory: /opt/store/mysql/
- SSH user: vagrant
- SSH port: 22
- Authentication: SSH key (Ed25519)

## Команда синхронизации

```bash
rsync -av \
  -e "ssh -i /root/.ssh/mysql_backup_ed25519 -o IdentitiesOnly=yes -o BatchMode=yes" \
  /opt/mysql_backup/ \
  vagrant@192.168.56.31:/opt/store/mysql/
```

## Параметры

- `-a` — архивный режим.
- `-v` — подробный вывод.
- `-e` — использование SSH для передачи файлов.
- `IdentitiesOnly=yes` — использование указанного SSH-ключа.
- `BatchMode=yes` — запрет интерактивного запроса пароля.

## Автоматизация

Синхронизация выполняется скриптом `mysql-backup.sh`
после успешного создания резервной копии MySQL.

Скрипт запускается каждый час через cron.

Отдельный rsync daemon не используется,
поэтому файл `/etc/rsyncd.conf` не требуется.

