FROM ubi8-minimal as dotnet-sdk
USER root
RUN microdnf install -y dotnet-sdk-9.0 && microdnf clean all
FROM ubi8-minimal as dotnet-runtime
USER root
RUN microdnf install -y dotnet-runtime-9.0 aspnetcore-runtime-9.0 && microdnf clean all

FROM dotnet-sdk as builder

COPY . /app

WORKDIR /app

RUN ["dotnet", "restore"]
RUN ["dotnet", "build"]

FROM dotnet-runtime

COPY --from=builder /app/bin/Debug/net9.0/ /app/
WORKDIR /app
EXPOSE 8080
ENTRYPOINT ["dotnet", "orders.NET.dll"]
