# go2-humble-docker

Unitree Go2 EDU를 ROS2 Humble로 제어하기 위한 Docker 개발 환경.

## Prerequisites

- Docker, Docker Compose
- Go2 EDU + 이더넷 연결 (192.168.123.x 대역)
- GPU 사용 시: [nvidia-container-toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
- Jetson 사용 시: JetPack 6.x

## Quick Start

**1. 컨테이너 실행**

```bash
# 기본 (CPU)
docker compose up -d go2-humble-docker

# GPU
docker compose --profile gpu up -d

# Jetson
docker compose --profile jetson up -d
```

**2. 컨테이너 진입**

```bash
docker exec -it go2-humble-docker bash
```

**3. 의존성 설치 (컨테이너 내부)**

```bash
bash ~/go2-humble-docker/scripts/install_deps.sh
```

CycloneDDS 0.10.x + unitree_ros2 패키지를 빌드하고 `setup.sh`를 생성합니다.

## Usage

```bash
source ~/go2-humble-docker/src/unitree_ros2/setup.sh
ros2 topic list
```

Go2가 연결되어 있으면 `/sportmodestate`, `/lowstate` 등의 토픽이 표시됩니다.

## Notes

- **네트워크 인터페이스 변경:** `install_deps.sh` 상단의 `NETWORK_INTERFACE` 변수를 수정 후 재실행 (기본값: `eth0`)
