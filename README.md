# cloudberry
Misc. Scripts &amp; Configurations for a Raspberry Pi Cluster

## Setting up Shared SSD

1. Format disk as ext4
2. Mount disk to master. E.g, assuming disk is at /dev/sda
    ```bash
    pi@k8s-master:~ $ sudo mkdir /mnt/disk_name
    pi@k8s-master:~ $ sudo chown -R pi:pi /mnt/disk_name
    pi@k8s-master:~ $ sudo mount /dev/sda /mnt/disk_name
    ```
3. Set the disk to mount at startup (on master):
    ```bash
    # Find UUID of mounted disk
    pi@k8s-master:~ $ sudo blkid
    /dev/mmcblk0p2: LABEL="writable" UUID="13641ce7-7d4d-46c3-a37d-955cecb6ac61" TYPE="ext4" PARTUUID="d3408824-02"
    /dev/mmcblk0p1: SEC_TYPE="msdos" LABEL_FATBOOT="system-boot" LABEL="system-boot" UUID="E40B-247F" TYPE="vfat" PARTUUID="d3408824-01"
    /dev/sda: LABEL="berrystore1" UUID="e175687d-b36f-4a69-97cc-86ec5a42e1fe" TYPE="ext4"
    ```

    ```bash
    # Using UUID from above, append to /etc/fstab
    UUID=0ac98c2c-8c32-476b-9009-ffca123a2654 /mnt/disk_name ext4 defaults 0 0
    ```
4. Reboot and check that disk is mounted correctly:
    ```bash
    pi@k8s-master:~ $ df -ha /dev/sda
    Filesystem      Size  Used Avail Use% Mounted on
    /dev/sda        458G   73M  435G   1% /mnt/disk_name
    ```
5. Share the drive via NFS server

    a. Install dependencies
    ```bash
    pi@k8s-master:~ $ sudo apt-get install nfs-kernel-server -y
    ```
    b. Append to /etc/exports (on master)
    ```bash
    pi@k8s-master:~ $ sudo vi /etc/exports

    /mnt/disk_name *(rw,no_root_squash,insecure,async,no_subtree_check,anonuid=1000,anongid=1000)
    ```
    c. Start the server
    ```bash
    pi@k8s-master:~ $ sudo exportfs -ra
    ```
6. On worker nodes, install dependencies and create mount directory
    ```bash
    pi@k8s-worker1:~ $ sudo apt-get install nfs-common -y
    pi@k8s-worker1:~ $ sudo mkdir /mnt/disk_name
    pi@k8s-worker1:~ $ sudo chown -R pi:pi /mnt/disk_name/
    ```
7. Configure automount on workers by appending the following to /etc/fstab:
    ```bash
    # xxx.xxx.xx.xxx should be the ip of the master node.
    xxx.xxx.xx.xxx:/mnt/disk_name   /mnt/disk_name   nfs    rw  0  0
    ```
8. Reboot worker node(s).

