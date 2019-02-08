FROM opensuse:leap

# Add the machinery repository
RUN zypper ar -G -f http://download.opensuse.org/repositories/systemsmanagement:/machinery/openSUSE_Leap_42.1/ machinery
# Install machinery
RUN zypper -n --gpg-auto-import-keys install machinery
