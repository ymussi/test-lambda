interface body {
  message?: string;
  error?: string;
}

export interface ResponseBodyType {
  statusCode: number;
  body: body;
}
