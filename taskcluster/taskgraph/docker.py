# -*- coding: utf-8 -*-

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

from __future__ import absolute_import, print_function, unicode_literals

import json
import os
import subprocess
import tarfile
import tempfile
import urllib2
import which

from taskgraph.util import docker

GECKO = os.path.realpath(os.path.join(__file__, '..', '..', '..'))
IMAGE_DIR = os.path.join(GECKO, 'testing', 'docker')
INDEX_URL = 'https://index.taskcluster.net/v1/task/' + docker.INDEX_PREFIX + '.{}.{}.hash.{}'
ARTIFACT_URL = 'https://queue.taskcluster.net/v1/task/{}/artifacts/{}'


def load_image_by_name(image_name):
    context_path = os.path.join(GECKO, 'testing', 'docker', image_name)
    context_hash = docker.generate_context_hash(GECKO, context_path, image_name)

    image_index_url = INDEX_URL.format('mozilla-central', image_name, context_hash)
    print("Fetching", image_index_url)
    task = json.load(urllib2.urlopen(image_index_url))

    return load_image_by_task_id(task['taskId'])


def load_image_by_task_id(task_id):
    # because we need to read this file twice (and one read is not all the way
    # through), it is difficult to stream it.  So we download to disk and then
    # read it back.
    filename = 'temp-docker-image.tar'

    artifact_url = ARTIFACT_URL.format(task_id, 'public/image.tar.zst')
    print("Downloading", artifact_url)
    tempfilename = 'temp-docker-image.tar.zst'
    subprocess.check_call(['curl', '-#', '-L', '-o', tempfilename, artifact_url])
    print("Decompressing")
    subprocess.check_call(['zstd', '-d', tempfilename, '-o', filename])
    print("Deleting temporary file")
    os.unlink(tempfilename)

    print("Determining image name")
    tf = tarfile.open(filename)
    repositories = json.load(tf.extractfile('repositories'))
    name = repositories.keys()[0]
    tag = repositories[name].keys()[0]
    name = '{}:{}'.format(name, tag)
    print("Image name:", name)

    print("Loading image into docker")
    try:
        subprocess.check_call(['docker', 'load', '-i', filename])
    except subprocess.CalledProcessError:
        print("*** `docker load` failed.  You may avoid re-downloading that tarball by fixing the")
        print("*** problem and running `docker load < {}`.".format(filename))
        raise

    print("Deleting temporary file")
    os.unlink(filename)

    print("The requested docker image is now available as", name)
    print("Try: docker run -ti --rm {} bash".format(name))


def build_context(name, outputFile):
    """Build a context.tar for image with specified name.
    """
    if not name:
        raise ValueError('must provide a Docker image name')
    if not outputFile:
        raise ValueError('must provide a outputFile')

    image_dir = os.path.join(IMAGE_DIR, name)
    if not os.path.isdir(image_dir):
        raise Exception('image directory does not exist: %s' % image_dir)

    docker.create_context_tar(GECKO, image_dir, outputFile, "")


def build_image(name):
    """Build a Docker image of specified name.

    Output from image building process will be printed to stdout.
    """
    if not name:
        raise ValueError('must provide a Docker image name')

    image_dir = os.path.join(IMAGE_DIR, name)
    if not os.path.isdir(image_dir):
        raise Exception('image directory does not exist: %s' % image_dir)

    tag = docker.docker_image(name, default_version='latest')

    docker_bin = which.which('docker')

    # Verify that Docker is working.
    try:
        subprocess.check_output([docker_bin, '--version'])
    except subprocess.CalledProcessError:
        raise Exception('Docker server is unresponsive. Run `docker ps` and '
                        'check that Docker is running')

    # We obtain a context archive and build from that. Going through the
    # archive creation is important: it normalizes things like file owners
    # and mtimes to increase the chances that image generation is
    # deterministic.
    fd, context_path = tempfile.mkstemp()
    os.close(fd)
    try:
        docker.create_context_tar(GECKO, image_dir, context_path, name)
        docker.build_from_context(docker_bin, context_path, name, tag)
    finally:
        os.unlink(context_path)

    print('Successfully built %s and tagged with %s' % (name, tag))

    if tag.endswith(':latest'):
        print('*' * 50)
        print('WARNING: no VERSION file found in image directory.')
        print('Image is not suitable for deploying/pushing.')
        print('Create an image suitable for deploying/pushing by creating')
        print('a VERSION file in the image directory.')
        print('*' * 50)
