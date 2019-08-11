# borgScripts

## Usage

### createArchive.sh
Creates an archive to backup the data contained in the Documents, Pictures and Videos from the home directory. The data is backed up in a samba share mounted on /mnt/ in a repository backup located in the root of the share or the data can be backed up in a repository on a local disk.
The script also mount and unmount a samba share if the user request it.

### mountsmb.sh
Mount a samba share on /mnt/

### unmountsmb.sh
Unmount a samba share from /mnt/

