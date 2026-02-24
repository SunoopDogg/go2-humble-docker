#!/bin/bash
set -e

# ── Variables ──
PROJECT_ROOT="$HOME/go2-humble-docker"
UNITREE_ROS2_DIR="$PROJECT_ROOT/src/unitree_ros2"
CYCLONEDDS_WS="$UNITREE_ROS2_DIR/cyclonedds_ws"
NETWORK_INTERFACE="eth0"

apt update

apt install -y --no-install-recommends ros-humble-rmw-cyclonedds-cpp
apt install -y --no-install-recommends ros-humble-rosidl-generator-dds-idl
apt install -y --no-install-recommends libyaml-cpp-dev

apt install -y --no-install-recommends ros-humble-rviz2

cd "$PROJECT_ROOT/src"
git clone https://github.com/unitreerobotics/unitree_ros2.git

cd "$CYCLONEDDS_WS/src"

git clone https://github.com/ros2/rmw_cyclonedds -b humble
git clone https://github.com/eclipse-cyclonedds/cyclonedds -b releases/0.10.x

cd "$CYCLONEDDS_WS"

colcon build --packages-select cyclonedds

source /opt/ros/humble/setup.bash

cd "$CYCLONEDDS_WS"

colcon build

# ── Generate setup.sh ──
cat > "$UNITREE_ROS2_DIR/setup.sh" << 'SETUP_EOF'
#!/bin/bash
echo "Setup unitree ros2 environment"

# 1) ROS2 Humble 환경 로드
source /opt/ros/humble/setup.bash

# 2) CycloneDDS 워크스페이스 로드
source $HOME/go2-humble-docker/src/unitree_ros2/cyclonedds_ws/install/setup.bash

# 3) DDS 구현을 CycloneDDS로 변경
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
SETUP_EOF

cat >> "$UNITREE_ROS2_DIR/setup.sh" << SETUP_EOF

# 4) 네트워크 인터페이스 설정
export CYCLONEDDS_URI='<CycloneDDS><Domain><General><Interfaces>
  <NetworkInterface name="${NETWORK_INTERFACE}" priority="default" multicast="default" />
</Interfaces></General></Domain></CycloneDDS>'
SETUP_EOF

chmod +x "$UNITREE_ROS2_DIR/setup.sh"

echo "Generated setup.sh with NETWORK_INTERFACE=${NETWORK_INTERFACE}"

cd "$PROJECT_ROOT"

apt clean \
    && rm -rf /var/lib/apt/lists/*
