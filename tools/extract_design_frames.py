import imageio.v3 as iio
from PIL import Image
from pathlib import Path

src = r"C:\Users\Павел\Desktop\IMG_9236.MP4"
out = Path(r"C:\Users\Павел\trading_education_app\store\assets\design_ref")
out.mkdir(parents=True, exist_ok=True)

frames = []
for i, frame in enumerate(iio.imiter(src, plugin="pyav")):
    frames.append(frame)
    if i > 500:
        break

print("sampled frames:", len(frames))
if not frames:
    raise SystemExit("no frames")

print("shape:", frames[0].shape)
n = len(frames)
idxs = sorted(set(int(i * (n - 1) / 7) for i in range(8)))
for j, idx in enumerate(idxs):
    img = Image.fromarray(frames[idx])
    path = out / f"frame_{j+1:02d}.png"
    img.save(path)
    print("wrote", path.name, img.size)
