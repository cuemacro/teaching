raw_data_path = "/home/redhat/cuemacro/pythoncourse/notebooks/raw_data/"

import modin.pandas as pd
import numpy as np

frame_data = np.random.randint(0, 100, size=(2**10, 2**8))
df = pd.DataFrame(frame_data)

print(df)

df = pd.read_csv("my_dataset.csv")
