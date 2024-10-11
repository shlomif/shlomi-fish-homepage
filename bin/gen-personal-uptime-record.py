# mandel - a function to generate the Mandelbrot Set.
# Written by Shlomi Fish, 2001
#
# This file is under the CC0 / public domain.

import subprocess

import numpy as np

# import png

r_width, i_height = 640, 640

# inspired by https://github.com/akkana/gimp-plugins/blob/master/gimp3/saver.py
# thanks


# Assign some default values to the parameters
def _gen_empty_image(x=r_width, y=i_height, num_steps=20,
                     init_value=0, max_level=255):
    x_len, y_len = zs = x, y
    ret = np.zeros(zs, dtype=np.longlong)
    return ret


GIMP_WRAPPER_FUNCS = '''
import gi
gi.require_version("Gimp", "3.0")
from gi.repository import Gimp
pdb = Gimp.get_pdb()

def gimp_wrap_run_pdb(pdb, name, kv):
    pdb_proc = pdb.lookup_procedure(name)
    pdb_config = pdb_proc.create_config()
    for k, v in kv.items():
        pdb_config.set_property(k, v)
    result = pdb_proc.run(pdb_config)
    arr = [result.index(i) for i in range(result.length())]
    return arr

def gimp_wrap_file_save(pdb, img, filepath):
    result = gimp_wrap_run_pdb(pdb, "gimp-file-save", {
    "file": Gio.File.new_for_path(filepath),
    "image": img,
    "run-mode": Gimp.RunMode.NONINTERACTIVE,
    })
    return result

def _only1(lst):
    assert(len(lst) == 1)
    ret = lst[0]
    return ret
'''


def main():
    mandelbrot_set = _gen_empty_image(max_level=255, num_steps=255)
    mandelbrot_set = mandelbrot_set.astype('uint8')
    # m = np.repeat(mandelbrot_set, 3, axis=1)
    before_fn = ("src/images/before-and-after-reboot-uptime-34-days/"
                 "before-reboot.png"
                 )
    gradient = "Tropical Colors"
    greyscale_fn = "mandelpy.dat"
    # colored_fn = "mandel_colored.png"
    # png.from_array(m, 'RGB').save(greyscale_fn)
    mandelbrot_set.tofile(greyscale_fn)
    greyscale_bmp = "mandelpy.bmp"
    colored_fn = greyscale_bmp
    subprocess.check_call(
        [
            "gm", "convert", "-depth", "8", "-size",
            "{}x{}+0".format(r_width, i_height),
            "gray:"+greyscale_fn, greyscale_bmp,
        ]
    )
    subprocess.check_call(
        [
            "gimp",  greyscale_bmp,
            # "gimp-2.99",  greyscale_fn,
            "--quit",
            "--no-interface",
            "--batch-interpreter=python-fu-eval",
            "-b",
            ('''
{GIMP_WRAPPER_FUNCS}
gradient_name = "{gradient}"
colored_fn = "{colored_fn}"
before_filepath = "{before_fn}"

images = Gimp.get_images()
img = _only1(images)
layers = img.get_layers()
draw = _only1(layers)
newlayer = gimp_wrap_run_pdb(pdb, "gimp-file-load-layer",
                             {{
    "file": Gio.File.new_for_path(before_filepath),
    "image": img,
    "run-mode": Gimp.RunMode.NONINTERACTIVE,
}})
# newlayer = _only1(newlayer)
print("newlayer = [", newlayer, "]")
newlayer = newlayer[-1]
gimp_wrap_run_pdb(pdb, "gimp-image-insert-layer",
                             {{
    "image": img,
    "layer": newlayer,
    "parent": None,
    "position": 0,
}})
gradient = Gimp.Gradient.get_by_name(gradient_name)
Gimp.context_set_gradient(gradient)
result = gimp_wrap_run_pdb(pdb, "plug-in-gradmap", {{
"drawables":
Gimp.ObjectArray.new(Gimp.Drawable, [draw, ], False),
"image": img,
"num-drawables": 1,
"run-mode": Gimp.RunMode.NONINTERACTIVE,
}})
gimp_wrap_file_save(
    pdb, img, colored_fn)
# Gimp.get_pdb().gimp_quit(1)
''').format(
                 before_fn=before_fn,
                 colored_fn=colored_fn,
                 gradient=gradient,
                 GIMP_WRAPPER_FUNCS=GIMP_WRAPPER_FUNCS,
             )
        ]
    )
    # raise "gimp was invoked"

    subprocess.check_call(["gwenview", colored_fn])


main()
