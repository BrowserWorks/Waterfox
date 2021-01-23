# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
import json
import importlib.util
import inspect
import os
import pathlib

from .logger import NotebookLogger
from mozperftest.metrics.exceptions import NotebookInvalidTransformError

logger = NotebookLogger()


class Transformer(object):
    """Abstract class for data transformers.
    """

    def __init__(self, files=None, custom_transformer=None):
        """Initialize the transformer with files.

        :param list files: A list of files containing data to transform.
        :param object custom_transformer: A custom transformer instance.
            Must implement `transform` and `merge` methods.
        """
        self._files = files

        if custom_transformer:
            valid = (
                hasattr(custom_transformer, "transform")
                and hasattr(custom_transformer, "merge")
                and callable(custom_transformer.transform)
                and callable(custom_transformer.merge)
            )

            if not valid:
                raise NotebookInvalidTransformError(
                    "The custom transformer must contain `transform` and `merge` methods."
                )

        self._custom_transformer = custom_transformer

    @property
    def files(self):
        return self._files

    @files.setter
    def files(self, val):
        if not isinstance(val, list):
            logger.warning("`files` must be a list, got %s" % type(val))
            return
        self._files = val

    def open_data(self, file):
        """Opens a file of data.

        If it's not a JSON file, then the data
        will be opened as a text file.

        :param str file: Path to the data file.
        :return: Data contained in the file.
        """
        with open(file) as f:
            if file.endswith(".json"):
                return json.load(f)
            return f.readlines()

    def process(self, name, **kwargs):
        """Process all the known data into a merged, and standardized data format.

        :param str name: Name of the merged data.
        :return dict: Merged data.
        """
        trfmdata = []

        for file in self.files:
            data = {}

            # Open data
            try:
                if hasattr(self._custom_transformer, "open_data"):
                    data = self._custom_transformer.open_data(file)
                else:
                    data = self.open_data(file)
            except Exception as e:
                logger.warning("Failed to open file %s, skipping" % file)
                logger.warning("%s %s" % (e.__class__.__name__, e))

            # Transform data
            try:
                data = self._custom_transformer.transform(data, **kwargs)
                if not isinstance(data, list):
                    data = [data]
                for entry in data:
                    for ele in entry["data"]:
                        ele.update({"file": file})
                trfmdata.extend(data)
            except Exception as e:
                logger.warning("Failed to transform file %s, skipping" % file)
                logger.warning("%s %s" % (e.__class__.__name__, e))

        merged = self._custom_transformer.merge(trfmdata)

        if isinstance(merged, dict):
            merged["name"] = name
        else:
            for e in merged:
                e["name"] = name

        return merged


class SimplePerfherderTransformer:
    """Transforms perfherder data into the standardized data format.
    """

    entry_number = 0

    def transform(self, data):
        self.entry_number += 1
        return {
            "data": [{"value": data["suites"][0]["value"], "xaxis": self.entry_number}]
        }

    def merge(self, sde):
        merged = {"data": []}
        for entry in sde:
            if isinstance(entry["data"], list):
                merged["data"].extend(entry["data"])
            else:
                merged["data"].append(entry["data"])

        self.entry_number = 0
        return merged


def get_transformers(dirpath=None):
    """This function returns a dict of transformers under the given path.

    If more than one transformers have the same class name, an exception will be raised.

    :param str dirpath: Path to a directory containing the transformers.
    :return dict: {"transformer name": Transformer class}.
    """

    #
    # XXX: This function is broken when in-tree, we need to fix it eventually.
    #
    raise Exception("Do not use this function.")

    if not dirpath or not os.path.exists(dirpath):
        logger.warning(f"Could not find directory for transformers: {dirpath}")
        return {}

    ret = {}
    tfm_path = pathlib.Path(dirpath)

    if not tfm_path.is_dir():
        raise Exception(f"{tfm_path} is not a directory or it does not exist.")

    tfm_files = list(tfm_path.glob("*.py"))
    importlib.machinery.SOURCE_SUFFIXES.append("")
    for file in tfm_files:

        # Importing a source file directly
        spec = importlib.util.spec_from_file_location(
            name=file.name, location=file.resolve().as_posix()
        )
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)

        members = inspect.getmembers(
            module, lambda c: inspect.isclass(c) and issubclass(c, Transformer)
        )

        for (name, tfm_class) in members:
            if name in ret and name != "Transformer":
                raise Exception(
                    f"""Duplicated transformer {name} is found in the folder {dirpath}.
                    Please define each transformer class with a unique class name."""
                )
            ret.update({name: tfm_class})

    return ret
