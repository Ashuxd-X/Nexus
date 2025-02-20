#!/bin/bash

# Define colors for output
GREEN="\e[32m"
RED="\e[31m"
NC="\e[0m"

echo -e "${GREEN}Creating Nexus CLI directory...${NC}"
mkdir -p nexus-cli && cd nexus-cli

echo -e "${GREEN}Installing Rust...${NC}"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env

echo -e "${GREEN}Adding Rust RISC-V target...${NC}"
rustup target add riscv32i-unknown-none-elf

echo -e "${GREEN}Updating system packages...${NC}"
sudo apt update

echo -e "${GREEN}Installing dependencies...${NC}"
sudo apt install -y pkg-config libssl-dev protobuf-compiler

echo -e "${GREEN}Installing Nexus CLI...${NC}"
curl https://cli.nexus.xyz/ | sh

echo -e "${GREEN}Installation complete!${NC}"
echo -e "🔹 Visit ${GREEN}https://beta.nexus.xyz/${NC} to get your Node ID."
echo -e "🔹 Restart with: ${GREEN}curl https://cli.nexus.xyz/ | sh${NC}"

# Protobuf fix instructions
read -p "Do you need to fix the protobuf error? (y/n): " fix_proto
if [[ "$fix_proto" == "y" || "$fix_proto" == "Y" ]]; then
    echo -e "${RED}Fixing protobuf issue...${NC}"
    sudo apt-get remove -y protobuf-compiler
    wget https://github.com/protocolbuffers/protobuf/releases/download/v30.0-rc1/protoc-30.0-rc-1-linux-x86_64.zip
    sudo unzip protoc-30.0-rc-1-linux-x86_64.zip -d /usr/local/
    sudo chmod +x /usr/local/bin/protoc
    echo -e "${GREEN}Protobuf fix completed!${NC}"
fi
