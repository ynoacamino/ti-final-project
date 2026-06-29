export interface LoginDTO {
  email: string;
  password: string;
}

export interface LoginResult {
  token: string;
  user: {
    id: string;
    email: string;
    name: string;
    role: "admin" | "customer";
  };
}

/**
 * Inbound port for the Login User use case.
 */
export interface ILoginUseCase {
  /**
   * Authenticates a user and generates a JWT.
   *
   * @param dto The login credentials
   * @returns A promise resolving to the login result containing user details and the token
   */
  execute(dto: LoginDTO): Promise<LoginResult>;
}
