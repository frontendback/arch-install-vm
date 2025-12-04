#!/bin/bash
#
# Mathisen's Arch Install Script for VMs
# Run with: curl -sL <your-github-raw-url> | bash
# Or: bash <(curl -sL <your-github-raw-url>)
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_msg() {
    echo -e "${GREEN}[*]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE} $1${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    print_error "This script must be run as root"
    exit 1
fi

# Check if running from Arch ISO
if [[ ! -f /etc/arch-release ]]; then
    print_error "This script must be run from an Arch Linux live environment"
    exit 1
fi

print_header "Mathisen's Arch Install Script for VMs"

# Detect boot mode
if [[ -d /sys/firmware/efi/efivars ]]; then
    BOOT_MODE="UEFI"
else
    BOOT_MODE="BIOS"
fi
print_msg "Detected boot mode: ${BOOT_MODE}"

# List available disks
print_header "Available Disks"
lsblk -d -o NAME,SIZE,MODEL | grep -v "loop\|sr"
echo ""

# Get disk selection
read -p "Enter the disk to install to (e.g., sda, vda, nvme0n1): " DISK
DISK="/dev/${DISK}"

if [[ ! -b "$DISK" ]]; then
    print_error "Disk $DISK does not exist!"
    exit 1
fi

# Confirm disk selection
print_warn "WARNING: This will ERASE ALL DATA on $DISK"
read -p "Are you sure you want to continue? (yes/no): " CONFIRM
if [[ "$CONFIRM" != "yes" ]]; then
    print_msg "Installation cancelled."
    exit 0
fi

# Get hostname
read -p "Enter hostname for this machine: " HOSTNAME
if [[ -z "$HOSTNAME" ]]; then
    HOSTNAME="archlinux"
fi

# Get timezone
print_msg "Example timezones: America/New_York, Europe/London, Asia/Tokyo"
read -p "Enter your timezone (or press Enter for UTC): " TIMEZONE
if [[ -z "$TIMEZONE" ]]; then
    TIMEZONE="UTC"
fi

# Verify timezone exists
if [[ ! -f "/usr/share/zoneinfo/$TIMEZONE" ]]; then
    print_warn "Timezone $TIMEZONE not found, using UTC"
    TIMEZONE="UTC"
fi

# Get root password
print_header "Root Password Setup"
while true; do
    read -s -p "Enter root password: " ROOT_PASSWORD
    echo ""
    read -s -p "Confirm root password: " ROOT_PASSWORD_CONFIRM
    echo ""
    if [[ "$ROOT_PASSWORD" == "$ROOT_PASSWORD_CONFIRM" ]]; then
        if [[ -z "$ROOT_PASSWORD" ]]; then
            print_warn "Password cannot be empty!"
        else
            break
        fi
    else
        print_warn "Passwords do not match, try again."
    fi
done

# Get username
print_header "User Account Setup"
read -p "Enter username for regular user: " USERNAME
if [[ -z "$USERNAME" ]]; then
    USERNAME="user"
fi

# Get user password
while true; do
    read -s -p "Enter password for $USERNAME: " USER_PASSWORD
    echo ""
    read -s -p "Confirm password for $USERNAME: " USER_PASSWORD_CONFIRM
    echo ""
    if [[ "$USER_PASSWORD" == "$USER_PASSWORD_CONFIRM" ]]; then
        if [[ -z "$USER_PASSWORD" ]]; then
            print_warn "Password cannot be empty!"
        else
            break
        fi
    else
        print_warn "Passwords do not match, try again."
    fi
done

# Summary
print_header "Installation Summary"
echo "Disk:       $DISK"
echo "Boot Mode:  $BOOT_MODE"
echo "Hostname:   $HOSTNAME"
echo "Timezone:   $TIMEZONE"
echo "Username:   $USERNAME"
echo ""
read -p "Proceed with installation? (yes/no): " FINAL_CONFIRM
if [[ "$FINAL_CONFIRM" != "yes" ]]; then
    print_msg "Installation cancelled."
    exit 0
fi

print_header "Starting Installation"

# Update system clock
print_msg "Syncing system clock..."
timedatectl set-ntp true

# Partitioning
print_msg "Partitioning disk $DISK..."

# Wipe existing partition table
wipefs -af "$DISK"

if [[ "$BOOT_MODE" == "UEFI" ]]; then
    # UEFI partitioning with GPT
    parted -s "$DISK" mklabel gpt
    parted -s "$DISK" mkpart "EFI" fat32 1MiB 513MiB
    parted -s "$DISK" set 1 esp on
    parted -s "$DISK" mkpart "swap" linux-swap 513MiB 4609MiB
    parted -s "$DISK" mkpart "root" ext4 4609MiB 100%
    
    # Determine partition naming
    if [[ "$DISK" == *"nvme"* ]] || [[ "$DISK" == *"mmcblk"* ]]; then
        PART_PREFIX="${DISK}p"
    else
        PART_PREFIX="${DISK}"
    fi
    
    EFI_PART="${PART_PREFIX}1"
    SWAP_PART="${PART_PREFIX}2"
    ROOT_PART="${PART_PREFIX}3"
    
    # Wait for partitions to appear
    sleep 2
    
    # Format partitions
    print_msg "Formatting partitions..."
    mkfs.fat -F32 "$EFI_PART"
    mkswap "$SWAP_PART"
    mkfs.ext4 -F "$ROOT_PART"
    
    # Mount partitions
    print_msg "Mounting partitions..."
    mount "$ROOT_PART" /mnt
    mkdir -p /mnt/boot
    mount "$EFI_PART" /mnt/boot
    swapon "$SWAP_PART"
    
else
    # BIOS partitioning with MBR
    parted -s "$DISK" mklabel msdos
    parted -s "$DISK" mkpart primary linux-swap 1MiB 4097MiB
    parted -s "$DISK" mkpart primary ext4 4097MiB 100%
    parted -s "$DISK" set 2 boot on
    
    # Determine partition naming
    if [[ "$DISK" == *"nvme"* ]] || [[ "$DISK" == *"mmcblk"* ]]; then
        PART_PREFIX="${DISK}p"
    else
        PART_PREFIX="${DISK}"
    fi
    
    SWAP_PART="${PART_PREFIX}1"
    ROOT_PART="${PART_PREFIX}2"
    
    # Wait for partitions to appear
    sleep 2
    
    # Format partitions
    print_msg "Formatting partitions..."
    mkswap "$SWAP_PART"
    mkfs.ext4 -F "$ROOT_PART"
    
    # Mount partitions
    print_msg "Mounting partitions..."
    mount "$ROOT_PART" /mnt
    swapon "$SWAP_PART"
fi

# Install base system
print_msg "Installing base system (this may take a while)..."
pacstrap /mnt base linux linux-firmware networkmanager grub sudo nano

# Install efibootmgr for UEFI systems
if [[ "$BOOT_MODE" == "UEFI" ]]; then
    pacstrap /mnt efibootmgr
fi

# Generate fstab
print_msg "Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

# Create chroot script
print_msg "Configuring system..."
cat > /mnt/install-chroot.sh << CHROOT_EOF
#!/bin/bash
set -e

# Set timezone
ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
hwclock --systohc

# Set locale
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Set hostname
echo "${HOSTNAME}" > /etc/hostname
cat > /etc/hosts << EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   ${HOSTNAME}.localdomain ${HOSTNAME}
EOF

# Enable NetworkManager
systemctl enable NetworkManager

# Set root password
echo "root:${ROOT_PASSWORD}" | chpasswd

# Create user
useradd -m -G wheel -s /bin/bash ${USERNAME}
echo "${USERNAME}:${USER_PASSWORD}" | chpasswd

# Configure sudo
echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers

# Install bootloader
if [[ "${BOOT_MODE}" == "UEFI" ]]; then
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ARCH
else
    grub-install --target=i386-pc ${DISK}
fi
grub-mkconfig -o /boot/grub/grub.cfg

CHROOT_EOF

chmod +x /mnt/install-chroot.sh
arch-chroot /mnt /install-chroot.sh
rm /mnt/install-chroot.sh

# Unmount and finish
print_msg "Unmounting partitions..."
umount -R /mnt
swapoff -a

print_header "Installation Complete!"
echo ""
echo "You can now reboot into your new Arch Linux system."
echo ""
echo "Login credentials:"
echo "  Root:     root / <your password>"
echo "  User:     ${USERNAME} / <your password>"
echo ""
echo "NetworkManager will start automatically on boot."
echo ""
read -p "Press Enter to reboot, or Ctrl+C to stay in live environment..."
reboot
