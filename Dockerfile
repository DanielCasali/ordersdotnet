#Step 1 create the dotnet sdk container from ubi8 calling it dotnet-sdk
FROM ubi8-minimal as dotnet-sdk
USER root
RUN microdnf install -y dotnet-sdk-9.0 && microdnf clean all

#######################
#Step 2 create the runtime container from ubi8 calling it dotnet-runtime
FROM ubi8-minimal as dotnet-runtime
USER root
RUN microdnf install -y dotnet-runtime-9.0 aspnetcore-runtime-9.0 && microdnf clean all

#######################
#Step 3 compile the dotnet project  container from the dotnet-sdka to copy later
FROM dotnet-sdk as builder
COPY . /app
WORKDIR /app
RUN ["dotnet", "restore"]
RUN ["dotnet", "build"]

#######################
#Step 4 create the app container from the dotnet-runtime I copy the compiled code from builder
FROM dotnet-runtime
COPY --from=builder /app/bin/Debug/net9.0/ /app/
WORKDIR /app
EXPOSE 8080
ENTRYPOINT ["dotnet", "orders.NET.dll"]
