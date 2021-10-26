# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

# generate rsa keys only for the first time
if not Narra::Tools::Settings.rsa_private_pem
  # generate keys
  private = OpenSSL::PKey::RSA.generate 2048
  # store them
  Narra::Tools::Settings.rsa_private_pem = private.to_pem
  Narra::Tools::Settings.rsa_public_pem = private.public_key.to_pem
end
