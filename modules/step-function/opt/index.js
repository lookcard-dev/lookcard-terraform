exports.handler = async (event) => {
  const message = event.message || "Hello from Lambda!";
  const response = {
    statusCode: 200,
    body: message,
  };
  return response;
};
