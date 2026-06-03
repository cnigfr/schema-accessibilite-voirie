import logging
import os

from cnig_accessibilite import create_gpkg, get_schema_version, upgrade_gpkg

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s %(levelname)s:%(message)s',
)

GPKG_PATH = "tests/cnig_accessibilite_test.gpkg"


def main():
    if os.path.exists(GPKG_PATH):
        os.remove(GPKG_PATH)

    create_gpkg(GPKG_PATH, srid=3948, revision="001")
    logging.info("Version after creation : %s", get_schema_version(GPKG_PATH))  # 001

    copy = upgrade_gpkg(GPKG_PATH)
    logging.info("Version after upgrade  : %s", get_schema_version(str(copy)))  # 002


if __name__ == "__main__":
    main()
