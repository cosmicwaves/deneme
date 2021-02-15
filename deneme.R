library(RCurl)
library(httr)
library(tidyverse)

url <-"https://raw.githubusercontent.com/cosmicwaves/deneme/main/Deneme.csv"
deneme <- read.csv(url, sep = ";", encoding = "UTF-8")

deneme <- deneme %>% 
  rename( years_in_tr = X.U.FEFF.Kaç.yıldır.Türkiye.desiniz.,
          years_in_gzt = Kaç.yıldır.Gaziantep.tesiniz.,
          years_back_in_gzt = Gaziantep.e.döneli.kaç.yıl.oldu.,
          another_city = Gaziantep.dışında.bir.ilde.yaşadınız.mı.,
          gzt_giris = Türkiye.ye.giriş.yaptıktan.sonra.Gaziantep.e.mi.yerleştiniz.
  )

# Mutations

deneme$years_in_tr <- str_replace_all(deneme$years_in_tr, "yıl","")
deneme$years_in_tr <- str_replace_all(deneme$years_in_tr, "dan az","")
deneme$years_in_tr <- str_replace_all(deneme$years_in_tr, "dan fazla","")

deneme$years_in_gzt <- str_replace_all(deneme$years_in_gzt, "yıl", "")
deneme$years_in_gzt <- str_replace_all(deneme$years_in_gzt, "dan az", "")

deneme$years_back_in_gzt <- str_replace_all(deneme$years_back_in_gzt, "yıl", "")
deneme$years_back_in_gzt <- str_replace_all(deneme$years_back_in_gzt, "dan az", "")

deneme$years_in_tr <- as.numeric(deneme$years_in_tr, na.rm = TRUE)
deneme$years_in_gzt <- as.numeric(deneme$years_in_gzt, na.rm = TRUE)
deneme$years_back_in_gzt <- as.numeric(deneme$years_back_in_gzt, na.rm = TRUE)



# Burada benim amacım kimin Gaziantep'te ne kadar yaşadığını öğrenmek
# Ama sorularda bazı kondisyonlar var
# Örneğin Türkiye'ye Gaziantep üzerinden mi giriş yaptınız = Evet
#                   ve
# Gaziantep'ten başka bir ilde yaşadınız mı = Hayır cevabını verirlerse
# "years_in_tr" sütunu onların Gaziantep'teki yaşama süresini veriyor.

# ANCAK,
# Türkiye'ye Gaziantep üzerinden giriş yapmadıysa years_in_gzt Gaziantep'te
# yaşadığı süreyi veriyor.

# Bir başka kondisyonsa Türkiye'ye Gaziantep üzerinden mi giriş yaptınız = Evet
#                       Gaziantep'ten başka bir ilde yaşadınız mı = Evet
# kondisyonu
# o zaman years_back_in_gzt bana Gaziantep'te yaşadığı süreyi veriyor

# KISACA
  # Türkiye'ye Gaziantep üzerinden mi giriş yaptınız = Evet
  # Gaziantep'ten başka bir ilde yaşadınız mı = Hayır
    #years_in_tr

  # Türkiye'ye Gaziantep üzerinden mi giriş yaptınız = Hayır
    #years_in_gzt

  # Türkiye'ye Gaziantep üzerinden mi giriş yaptınız = Evet
  # Gaziantep'ten başka bir ilde yaşadınız mı = Evet
    #years_back_in_gzt

# Buraya kadar hesaplamada sıkıntı yok. Ama şu durum biraz ortalığı karıştırıyor:
  # Bazıları Gaziantep'te yaşadıkları süreyi Türkiye'de yaşadıkları süreden daha uzun söylemişler.
  # Gaziantep'te yaşadıktan sonra başka ile gidip dönen kişilerin sürelerinde uyumsuzluk var.
  # Bunu for ve if yazarak çözmeye çalıştım ama başaramadım. : // Nasıl yapılır? : )

for(i in 1:nrow(deneme$years_in_tr)){
  if (deneme$years_in_tr[i] < deneme$years_in_gzt[i]){
    newv[i] = "NA"
  } else {
    newv[i] = deneme$years_in_gzt[i]
  }
}
