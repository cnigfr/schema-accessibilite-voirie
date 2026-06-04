"""Terminal commands tp create, upgrade and downgrade CNIG Accessibility GeoPackage files"""
import click
import logging

from cnig_accessibilite import create_gpkg, upgrade_gpkg, downgrade_gpkg, get_schema_version


def configure_logger():
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s %(levelname)s:%(message)s',
    )


@click.group('cnig_accessibilite')
def cli():
    configure_logger()


@cli.command()
@click.argument('gpkg_path', required=True)
@click.option(
    '--srid', '-srid', default=2154,
    help="Spatial reference id (default: 2154 EPSG code)"
)
@click.option(
    '--revision', '-r', default='head',
    help="revision to create (default: 'head')"
)
@click.option(
    '--overwrite', '-o', 'overwrite', is_flag=True,
    help="Overwrite gpkg if it exists already"
)
def create(gpkg_path, srid, overwrite, revision):
    create_gpkg(gpkg_path, srid, overwrite, revision)


@cli.command()
@click.argument('gpkg_path', required=True)
@click.option(
    '--revision', '-r', default='+1',
    help="revision to upgrade to (default: last revision)"
)
@click.option(
    '--output', '-o', default=None,
    help="output path for the upgraded copy (default: auto-named)"
)
def upgrade(gpkg_path, revision, output):
    upgrade_gpkg(gpkg_path, revision, output_path=output)


@cli.command()
@click.argument('gpkg_path', required=True)
@click.option(
    '--revision', '-r', default='-1',
    help="revision to downgrade to (default: '-1')"
)
@click.option(
    '--output', '-o', default=None,
    help="output path for the downgraded copy (default: auto-named)"
)
def downgrade(gpkg_path, revision, output):
    downgrade_gpkg(gpkg_path, revision, output_path=output)


@cli.command()
@click.argument('gpkg_path', required=True)
def version(gpkg_path):
    rev = get_schema_version(gpkg_path)
    logging.info("Current version %s" % rev)


if __name__ == '__main__':
    cli()
