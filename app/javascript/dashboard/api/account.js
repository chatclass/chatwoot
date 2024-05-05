/* global axios */
import ApiClient from './ApiClient';

class AccountAPI extends ApiClient {
  constructor() {
    super('', { accountScoped: true });
  }

  createAccount(data) {
    return axios.post(`${this.apiVersion}/accounts`, data);
  }

  /*hideTemplate(id) {
    return axios.post(`${this.apiVersion}/accounts`, id);
  }*/
}

export default new AccountAPI();
