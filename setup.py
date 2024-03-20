import multiprocessing
import pathlib

from setuptools import Extension, setup
from setuptools.command.build_ext import build_ext as build_ext_orig


class CMakeExtension(Extension):
    def __init__(self, name: str, path: pathlib.Path) -> None:
        super().__init__(name, sources=[])
        self.path = path


class build_ext(build_ext_orig):
    def build_extension(self, ext: Extension) -> None:
        if isinstance(ext, CMakeExtension):
            self.build_cmake(ext)
        else:
            super().build_extension(ext)

    def build_cmake(self, ext: CMakeExtension) -> None:
        build_temp = pathlib.Path(self.build_temp).resolve()
        build_temp.mkdir(parents=True, exist_ok=True)

        extdir = pathlib.Path(self.get_ext_fullpath("")).resolve().parent
        extdir.mkdir(parents=True, exist_ok=True)

        config = "Debug" if self.debug else "Release"

        self.spawn(
            [
                "cmake",
                "-S",
                str(ext.path),
                "-B",
                str(build_temp),
                f"-DCMAKE_BUILD_TYPE={config}",
                "-DINSTALL_SUBPATH=.",
            ]
        )
        self.spawn(
            [
                "cmake",
                "--build",
                str(build_temp),
                "--config",
                str(config),
                "--parallel",
                str(self.parallel or multiprocessing.cpu_count()),
            ]
        )
        self.spawn(
            [
                "cmake",
                "--install",
                str(build_temp),
                "--prefix",
                str(extdir),
                "--config",
                config,
            ]
        )


setup(
    ext_modules=[CMakeExtension("QuickGraphLib", pathlib.Path(__file__).parent)],
    cmdclass={"build_ext": build_ext},
)
