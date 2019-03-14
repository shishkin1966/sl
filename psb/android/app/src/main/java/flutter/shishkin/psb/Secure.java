package flutter.shishkin.psb;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.security.KeyPairGeneratorSpec;
import android.security.keystore.KeyGenParameterSpec;
import android.security.keystore.KeyProperties;
import android.util.Base64;


import java.math.BigInteger;
import java.nio.charset.Charset;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.KeyStore;
import java.security.MessageDigest;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.MGF1ParameterSpec;
import java.security.spec.RSAKeyGenParameterSpec;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.concurrent.locks.ReentrantLock;

import javax.crypto.Cipher;
import javax.crypto.spec.OAEPParameterSpec;
import javax.crypto.spec.PSource;
import javax.security.auth.x500.X500Principal;

@TargetApi(19)
public class Secure {
    public static final Charset UTF_8 = Charset.forName("UTF-8");
    private static final String ANDROID_KEYSTORE_INSTANCE = "AndroidKeyStore";
    private static final String HASH_ALGORITHM = "MD5";
    private static final String KEY_ALGORITHM = "RSA";
    private static final String TRANSFORMATION = "RSA/ECB/PKCS1Padding";
    private static final String TRANSFORMATION_M = "RSA/ECB/OAEPWithSHA-256AndMGF1Padding";
    private static volatile Secure sInstance;
    private KeyStore keyStore;
    private String alias;
    private ReentrantLock lock = new ReentrantLock();
    private boolean isHardwareSupport = false;

    private Secure(Context context) {
        try {
            String name = context.getPackageName();
            final MessageDigest digest = MessageDigest.getInstance(HASH_ALGORITHM);
            final byte[] hash = digest.digest(name.getBytes(UTF_8));
            alias = byteArrayToHex(hash);

            keyStore = KeyStore.getInstance(ANDROID_KEYSTORE_INSTANCE);
            keyStore.load(null);
            isHardwareSupport = checkKeyPair(context);
        } catch (Exception e) {
        }
    }

    public static Secure getInstance(Context context) {
        if (sInstance == null) {
            synchronized (Secure.class) {
                if (sInstance == null) {
                    sInstance = new Secure(context);
                }
            }
        }
        return sInstance;
    }

    private static String byteArrayToHex(byte[] a) {
        final StringBuilder sb = new StringBuilder(a.length * 2);
        for (byte b : a) {
            sb.append(String.format("%02x", b & 0xff));
        }
        return sb.toString();
    }

    private boolean checkKeyPair(Context context) {
        lock.lock();
        try {
            if (!keyStore.containsAlias(alias)) {
                if (createKeyPair(context)) {
                    return true;
                }
            } else {
                return true;
            }
        } catch (Exception e) {
        } finally {
            lock.unlock();
        }
        return false;
    }

    private boolean createKeyPair(Context context) {
        KeyPairGenerator keyPairGenerator = null;

        try {
            /**
             * On Android Marshmellow we can use new security features
             */
            if (Build.VERSION.SDK_INT >= 23) {
                keyPairGenerator = KeyPairGenerator.getInstance(
                        KEY_ALGORITHM, ANDROID_KEYSTORE_INSTANCE);

                keyPairGenerator.initialize(
                        new KeyGenParameterSpec.Builder(
                                alias,
                                KeyProperties.PURPOSE_ENCRYPT | KeyProperties.PURPOSE_DECRYPT)
                                .setBlockModes(KeyProperties.BLOCK_MODE_ECB)
                                .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_RSA_OAEP)
                                .setDigests(KeyProperties.DIGEST_SHA256, KeyProperties.DIGEST_SHA512)
                                .setAlgorithmParameterSpec(new RSAKeyGenParameterSpec(2048, RSAKeyGenParameterSpec.F4))
                                .setKeySize(2048)
                                .build());
            } else {
                if (Build.VERSION.SDK_INT >= 19) {
                    final Calendar start = new GregorianCalendar();
                    final Calendar end = new GregorianCalendar();
                    end.add(Calendar.ERA, 1);

                    KeyPairGeneratorSpec keyPairGeneratorSpec =
                            new KeyPairGeneratorSpec.Builder(context)
                                    .setAlias(alias)
                                    // The subject used for the self-signed certificate of the generated pair
                                    .setSubject(new X500Principal("CN=" + context.getPackageName()))
                                    // The serial number used for the self-signed certificate of the
                                    // generated pair.
                                    .setKeyType(KeyProperties.KEY_ALGORITHM_RSA)
                                    .setKeySize(2048)
                                    .setSerialNumber(BigInteger.valueOf(1967))
                                    .setStartDate(start.getTime())
                                    .setEndDate(end.getTime())
                                    .build();

                    keyPairGenerator = KeyPairGenerator
                            .getInstance(KEY_ALGORITHM, ANDROID_KEYSTORE_INSTANCE);
                    keyPairGenerator.initialize(keyPairGeneratorSpec);
                }
            }
            final KeyPair keyPair = keyPairGenerator.generateKeyPair();
            if (keyPair == null) {
                return false;
            }
        } catch (Exception e) {
            return false;
        }
        return true;
    }

    public String encode(final String data) {
        if (!isHardwareSupport) return null;

        String dataEncrypted = null;

        lock.lock();
        try {
            dataEncrypted = encryptBase64(data);
        } catch (Exception e) {
        } finally {
            lock.unlock();
        }
        return dataEncrypted;
    }

    private String encryptBase64(final String data) {
        if (!isHardwareSupport) return null;

        lock.lock();

        KeyStore.PrivateKeyEntry privateKeyEntry = null;
        try {
            privateKeyEntry = (KeyStore.PrivateKeyEntry) keyStore.getEntry(alias, null);
        } catch (Exception e) {
        }

        try {
            if (privateKeyEntry != null) {
                final PublicKey publicKey = privateKeyEntry.getCertificate().getPublicKey();
                return encryptBase64(data, publicKey);
            }
        } catch (Exception e) {
        } finally {
            lock.unlock();
        }

        return null;
    }

    private String encryptBase64(final String utf8string, final PublicKey publicKey) {
        if (utf8string == null) {
            return null;
        }

        if (publicKey == null) {
            return null;
        }
        try {
            final byte[] dataBytes = utf8string.getBytes(UTF_8);
            Cipher cipher = null;
            if (Build.VERSION.SDK_INT >= 23) {
                cipher = Cipher.getInstance(TRANSFORMATION_M);
            } else {
                cipher = Cipher.getInstance(TRANSFORMATION);
            }
            if (Build.VERSION.SDK_INT >= 26) {
                OAEPParameterSpec sp = new OAEPParameterSpec("SHA-256",
                        "MGF1", new MGF1ParameterSpec("SHA-1"),
                        PSource.PSpecified.DEFAULT);
                cipher.init(Cipher.ENCRYPT_MODE, publicKey, sp);
            } else {
                cipher.init(Cipher.ENCRYPT_MODE, publicKey);
            }
            return Base64.encodeToString(cipher.doFinal(dataBytes), Base64.DEFAULT);
        } catch (Exception e) {
        }
        return null;
    }

    public String decode(final String data) {
        if (!isHardwareSupport) return null;

        lock.lock();

        try {
            return decryptBase64(data);
        } catch (Exception e) {
        } finally {
            lock.unlock();
        }
        return null;
    }

    private String decryptBase64(final String base64string, final PrivateKey privateKey) {
        if (base64string == null) {
            return null;
        }

        if (privateKey == null) {
            return null;
        }

        try {
            final byte[] dataBytes = Base64.decode(base64string, Base64.DEFAULT);
            Cipher cipher = null;
            if (Build.VERSION.SDK_INT >= 23) {
                cipher = Cipher.getInstance(TRANSFORMATION_M);
            } else {
                cipher = Cipher.getInstance(TRANSFORMATION);
            }
            if (Build.VERSION.SDK_INT >= 26) {
                OAEPParameterSpec sp = new OAEPParameterSpec("SHA-256",
                        "MGF1", new MGF1ParameterSpec("SHA-1"),
                        PSource.PSpecified.DEFAULT);
                cipher.init(Cipher.DECRYPT_MODE, privateKey, sp);
            } else {
                cipher.init(Cipher.DECRYPT_MODE, privateKey);
            }
            return new String(cipher.doFinal(dataBytes));
        } catch (Exception e) {
        }
        return null;
    }

    private String decryptBase64(final String base64string) {
        if (!isHardwareSupport) return null;

        lock.lock();

        KeyStore.PrivateKeyEntry privateKeyEntry = null;
        try {
            privateKeyEntry = (KeyStore.PrivateKeyEntry) keyStore.getEntry(alias, null);
        } catch (Exception e) {
        }

        try {
            if (privateKeyEntry != null) {
                final PrivateKey privateKey = privateKeyEntry.getPrivateKey();
                return decryptBase64(base64string, privateKey);
            }
        } catch (Exception e) {
        } finally {
            lock.unlock();
        }
        return null;
    }



}
