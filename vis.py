import time
import numpy as np
import tkinter as tk
from PIL import ImageTk, Image
import logging
import sys

np.random.seed(1)
PhotoImage = ImageTk.PhotoImage
# UNIT = 40  # pixels
# HEIGHT = 5  # grid height
# WIDTH = 5  # grid width

IMAGE_ICON_SIZE = 25

GO_UP = 0
GO_DOWN = 1
GO_LEFT = 2
GO_RIGHT = 3

STEP_PENALTY = -1
INVALID_STEP_PENALTY = -10

class Env(tk.Tk):
    def __init__(self, info):
        super(Env, self).__init__()

        # Environment info
        self.env_info = info["env"]

        self.Ny = self.env_info["Ny"]
        self.Nx = self.env_info["Nx"]

        self.UNIT = 80

        if "Unit" in self.env_info:
            self.UNIT = self.env_info["Unit"]

        self.WIDTH = self.Nx
        self.HEIGHT = self.Ny
        # ********* ***********

        self.title('Penalty Solver')
        self.geometry('{0}x{1}'.format(self.WIDTH * self.UNIT, self.HEIGHT * self.UNIT))
        self.shapes = self._load_images()
        self.canvas = self._build_canvas()

        self._pack_canvas()

        self._create_elements()
        # ************* from other file ******************

    def _create_elements(self):
        x1 = self._get_row_center_pixel(2)
        y1 = self._get_column_center_pixel(2)
        resource_ball_static = self.canvas.create_image(y1, x1, image=self.shapes[4])

        # defenders
        x2 = self._get_row_center_pixel(11)
        y2 = self._get_column_center_pixel(11)
        resource_blocked_defender_1 = self.canvas.create_image(y2, x2, image=self.shapes[3])

        x2 = self._get_row_center_pixel(12)
        y2 = self._get_column_center_pixel(12)
        resource_blocked_defender_2 = self.canvas.create_image(y2, x2, image=self.shapes[3])

        x2 = self._get_row_center_pixel(13)
        y2 = self._get_column_center_pixel(13)
        resource_blocked_defender_3 = self.canvas.create_image(y2, x2, image=self.shapes[3])


        # goal keeper
        x2 = self._get_row_center_pixel(21)
        y2 = self._get_column_center_pixel(21)
        resource_blocked_1 = self.canvas.create_image(y2, x2, image=self.shapes[3])

        x2 = self._get_row_center_pixel(22)
        y2 = self._get_column_center_pixel(22)
        resource_blocked_2 = self.canvas.create_image(y2, x2, image=self.shapes[3])

        x2 = self._get_row_center_pixel(23)
        y2 = self._get_column_center_pixel(23)
        resource_blocked_3 = self.canvas.create_image(y2, x2, image=self.shapes[3])

    def _get_row(self, pos):
        return pos // self.WIDTH

    def _get_col(self, pos):
        return pos % self.WIDTH

    def _get_row_center_pixel(self, pos):
        row = self._get_row(pos)

        return int(row*self.UNIT + self.UNIT / 2)

    def _get_column_center_pixel(self, pos):
        col = self._get_col(pos)

        return int(col*self.UNIT + self.UNIT / 2)

    def _build_canvas(self):
        canvas = tk.Canvas(self, bg='white',
                           height=self.HEIGHT * self.UNIT,
                           width=self.WIDTH * self.UNIT)
        # create grids
        for c in range(0, self.WIDTH * self.UNIT, self.UNIT):  # 0~400 by 80
            x0, y0, x1, y1 = c, 0, c, self.HEIGHT * self.UNIT
            canvas.create_line(x0, y0, x1, y1)
        for r in range(0, self.HEIGHT * self.UNIT, self.UNIT):  # 0~400 by 80
            x0, y0, x1, y1 = 0, r, self.HEIGHT * self.UNIT, r
            canvas.create_line(x0, y0, x1, y1)

        return canvas

    def render(self):
        time.sleep(0.03)
        self.update()

    def _pack_canvas(self):
        self.canvas.pack()

    def _load_images(self):
        rectangle = PhotoImage(
            Image.open("img/rectangle.png").resize((IMAGE_ICON_SIZE, IMAGE_ICON_SIZE)))
        triangle = PhotoImage(
            Image.open("img/triangle.png").resize((IMAGE_ICON_SIZE, IMAGE_ICON_SIZE)))
        circle = PhotoImage(
            Image.open("img/circle.png").resize((IMAGE_ICON_SIZE, IMAGE_ICON_SIZE)))

        cross = PhotoImage(
            Image.open("img/cross.png").resize((IMAGE_ICON_SIZE, IMAGE_ICON_SIZE)))

        ball_starting_point = PhotoImage(
            Image.open("img/circle_static.png").resize((IMAGE_ICON_SIZE, IMAGE_ICON_SIZE)))


        return rectangle, triangle, circle, cross, ball_starting_point


    @staticmethod
    def setup_custom_logger(name, level, file_name='log.txt'):
        formatter = logging.Formatter(fmt='%(asctime)s %(levelname)-8s %(message)s',
                                      datefmt='%Y-%m-%d %H:%M:%S')
        handler = logging.FileHandler(file_name, mode='w')
        handler.setFormatter(formatter)
        # screen_handler = logging.StreamHandler(stream=sys.stdout)
        # screen_handler.setFormatter(formatter)
        logger = logging.getLogger(name)
        logger.setLevel(level)
        logger.addHandler(handler)
        # logger.addHandler(screen_handler)

        return logger



if __name__ == "__main__":
    info = {
        "env": {"Ny": 5,
                "Nx": 5},
    }

    env = Env(info)

    while True:
        env.render()