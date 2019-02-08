FROM opensuse:leap

# Add the machinery repository
## https://software.opensuse.org/ymp/systemsmanagement:machinery/openSUSE_Leap_15.0/machinery.ymp
RUN zypper ar -G -f http://download.opensuse.org/repositories/systemsmanagement:/machinery/openSUSE_Leap_15.0/
# Install machinery
RUN zypper -n --gpg-auto-import-keys install machinery
