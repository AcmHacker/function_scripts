from PIL import Image
import cv2
import numpy as np
import os

def check_contour(alpha_image, contour):
    # 获取轮廓的边界框
    x, y, w, h = cv2.boundingRect(contour)
    # 判断x - 1, y - 1, x + w + 1, y + h + 1这个矩形是否是透明的
    if x == 0 or y == 0 or y + h + 1 > alpha_image.shape[0] or x + w + 1 > alpha_image.shape[1]:
        return True
    v1 = alpha_image[y-1:y, x:x+w]
    # 判断v1是否都是0
    if np.sum(v1) != 0:
        return False
    v2 = alpha_image[y+h:y+h+1, x:x+w]
    # 判断v2是否都是0
    if np.sum(v2) != 0:
        return False
    v3 = alpha_image[y:y+h, x+w:x+w+1]
    # 判断v3是否都是0
    if np.sum(v3) != 0:
        return False
    v4 = alpha_image[y:y+h, x-1:x]
    # 判断v4是否都是0
    if np.sum(v4) != 0:
        return False
    return True    
        
def split_sheet(sheet_path):
    atlas_image = cv2.imread(sheet_path, cv2.IMREAD_UNCHANGED)
    alpha_image = atlas_image[:, :, 3]  # 提取alpha层

    ret, alpha_mask = cv2.threshold(alpha_image, 127, 255, cv2.THRESH_BINARY)

    # contours, _ = cv2.findContours(alpha_image, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    contours, _ = cv2.findContours(alpha_mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    sprites = []
    idx = 0
    for contour in contours:
        x, y, w, h = cv2.boundingRect(contour)
        if not check_contour(alpha_image, contour):
            continue
        sprite = atlas_image[y:y+h, x:x+w]
        sprites.append(sprite)
        cv2.imwrite(f"out/{idx}_{x}_{y}_{w}_{h}.png", sprite)
        idx += 1
    return sprites

    
if __name__ == "__main__":
    split_sheet("xx.png")
