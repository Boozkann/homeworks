import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from statsmodels.stats.libqsturng.make_tbls import q0100

pd.set_option('display.max_columns', None)
pd.set_option('display.width', 500)

pd.read_csv(r"C:\Users\ozkan\OneDrive\Desktop\GIT\odev\amazon_review.csv")

df = pd.read_csv(r"C:\Users\ozkan\OneDrive\Desktop\GIT\odev\amazon_review.csv")

import math
import scipy.stats as st
from sklearn.preprocessing import MinMaxScaler

pd.set_option('display.max_columns', None)
pd.set_option('display.max_rows', None)
pd.set_option('display.width', 500)
pd.set_option('display.expand_frame_repr', False)
pd.set_option('display.float_format', lambda x: '%.5f' % x)

df.head()
df.columns

#####  E-ticaret platformlarında, ürünlere verilen puanların doğru bir şekilde hesaplanması ve yorumların etkili bir şekilde sıralanması büyük önem taşır.
#####  Bu, müşteri memnuniyetini artır, satıcıların ürünlerinin öne çıkmasını sağlar ve kullanıcıların daha sorunsuz bir alışveriş deneyimi yaşamasına yardımcı olur.
#####  Ancak, yanıltıcı veya yanlış sıralanmış yorumlar, ürün satışlarını olumsuz etkileyebilir ve hem maddi kayıplara hem de müşteri kaybına neden olabilir.
#####  Bu projede, ürün puanlarını güncel yorumlara göre ağırlıklandırarak hesaplamayı ve yorumları etkili bir şekilde sıralamayı amaçlıyoruz.

#####Görev 1: Güncel Yorumlara Göre Ortalama Puanı Hesaplayın

#a) Ürünün mevcut ortalama puanını hesaplayın.

df.shape
df["overall"].mean()
df["overall"].value_counts()

df.info()

df["reviewTime"] = pd.to_datetime(df["reviewTime"])
df["reviewTime"].head()

df["reviewTime"].min()
df["reviewTime"].max()

current_date = df["reviewTime"].max()

df["days"] = (current_date - df["reviewTime"]).dt.days

df["days"].describe().T

q1= df["days"].quantile(0.25)
q2 = df["days"].quantile(0.50)
q3 = df["days"].quantile(0.75)
df["days"].describe().T





df.loc[df["days"] <= 280, "overall"].mean()

df.loc[(df["days"] > 280) & (df["days"] <= 430), "overall"].mean()

df.loc[(df["days"] > 430) & (df["days"] <= 600), "overall"].mean()

df.loc[(df["days"] > 600), "overall"].mean()

###Gün sayısı arttıkça puan düşmekte

df.loc[df["days"] <= 280, "overall"].mean() * 28/100 + \
    df.loc[(df["days"] > 280) & (df["days"] <= 430), "overall"].mean() * 26/100 + \
    df.loc[(df["days"] > 430) & (df["days"] <= 600), "overall"].mean() * 24/100 + \
    df.loc[(df["days"] > 600), "overall"].mean() * 22/100



def weighted_average_time_based(dataframe, w1=28, w2=26, w3=24, w4=22):
    return dataframe.loc[df["days"] <= 280, "overall"].mean() * w1 / 100 + \
           dataframe.loc[(dataframe["days"] > 280) & (dataframe["days"] <= 430), "overall"].mean() * w2 / 100 + \
           dataframe.loc[(dataframe["days"] > 430) & (dataframe["days"] <= 600), "overall"].mean() * w3 / 100 + \
           dataframe.loc[(dataframe["days"] > 600), "overall"].mean() * w4 / 100

weighted_average_time_based(df)

weighted_average_time_based(df, 28, 26, 24, 22)



###Ürün ortalama puanı 4.587 iken ortalama ağırlıklandırılmış puanımız 4.595 seviyesinde çıkmış olup, ortalama puana yakınsamıştır.

######Görev 2: Ürün Detay Sayfasında Görüntülenecek 20 Yorumu Belirleyin: Bu görevde, ürün detay sayfasında görüntülenecek en faydalı 20 yorumu belirleyeceksiniz.

##Adım 1: helpful_no değişkenini oluşturun.
#total_vote, bir yoruma verilen toplam oy sayısıdır.
#helpful_yes, yorumun faydalı bulunma sayısıdır.
#helpful_no değişkeni, toplam oy sayısından faydalı oy sayısını çıkararak hesaplanır:
#helpful_no = total_vote - helpful_yes


##Adım 2: score_pos_neg_diff, score_average_rating ve wilson_lower_bound skorlarını hesaplayın ve veri setine ekleyin.
#score_pos_neg_diff: Faydalı oy sayısı ile faydalı bulunmayan oy sayısı arasındaki fark.
#average_rating_score: Faydalı oy sayısının toplam oy sayısına oranı.
#wilsonlowerbound: Wilson Alt Sınırı, yorumun güvenilirliğini ölçen bir istatistiksel yöntemdir.

##Adım 3: Wilson Alt Sınırı'na göre en yüksek skora sahip ilk 20 yorumu belirleyin ve sonuçları yorumlayın.


df.sort_values(by="overall", ascending=False).head(20)

df["helpful_no"] = df["total_vote"] - df["helpful_yes"]


df["score_pos_neg_diff"] = df["helpful_yes"] - df["helpful_no"]
df["average_rating_score"] = df["helpful_yes"] / df["total_vote"]
df["average_rating_score"].fillna(0, inplace=True)

def score_pos_neg_diff(up, down):
    return up - down

df["score_pos_neg_diff"] = df.apply(lambda x: score_pos_neg_diff(x["helpful_yes"], x["helpful_no"]),axis=1)



def average_rating_score(up, down):
    if up + down == 0:
        return 0
    return up / (up + down)

df["average_rating_score"] = df.apply(lambda x: average_rating_score(x["helpful_yes"], x["helpful_no"]), axis=1)




df.describe().T
df.head(20)

df.sort_values("average_rating_score", ascending=False).head(20)


import numpy as np
from scipy.stats import norm

def wilson_lower_bound(helpful_yes, total_vote, confidence=0.95):
    if total_vote == 0:
        return 0
    z = norm.ppf(1 - (1 - confidence) / 2)
    phat = helpful_yes / total_vote
    return (phat + z**2 / (2 * total_vote) -
            z * np.sqrt((phat * (1 - phat) + z**2 / (4 * total_vote)) / total_vote)) / (1 + z**2 / total_vote)

df["wilson_lower_bound"] = df.apply(lambda x: wilson_lower_bound(x["helpful_yes"], x["total_vote"]), axis=1)

df.head(20)

top_20_reviews = df.sort_values("wilson_lower_bound", ascending=False).head(20)
print(top_20_reviews[["reviewText", "wilson_lower_bound"]])