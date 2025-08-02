# نستخدم صورة الـ SDK لبناء التطبيق
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app

# ننسخ ملفات المشروع ونقوم بعملية restore للحزم
COPY *.csproj ./
RUN dotnet restore

# ننسخ باقي ملفات المشروع
COPY . ./

# نبني المشروع بنسخة Release
RUN dotnet publish -c Release -o out

# نستخدم صورة الـ runtime لتشغيل التطبيق فقط (أخف)
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app

# ننسخ ملفات التطبيق المنشأة من مرحلة البناء
COPY --from=build /app/out ./

# نفتح البورت الافتراضي 80
EXPOSE 80

# الأمر الافتراضي لتشغيل التطبيق
ENTRYPOINT ["dotnet", "MyStoreAPI.dll"]
