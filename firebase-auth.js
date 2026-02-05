// Firebase 인증 유틸리티
import firebaseConfig from './firebase-config.js';

// Firebase 초기화
let auth = null;

export async function initializeFirebase() {
    if (auth) return auth;
    
    try {
        // Firebase SDK 동적 로드
        const { initializeApp } = await import('https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js');
        const { getAuth, signInWithEmailAndPassword, signOut, onAuthStateChanged } = 
            await import('https://www.gstatic.com/firebasejs/10.7.1/firebase-auth.js');
        
        // Firebase 앱 초기화
        const app = initializeApp(firebaseConfig);
        auth = getAuth(app);
        
        console.log('✅ Firebase 초기화 완료');
        return { auth, signInWithEmailAndPassword, signOut, onAuthStateChanged };
    } catch (error) {
        console.error('❌ Firebase 초기화 실패:', error);
        throw error;
    }
}

// 로그인 함수
export async function loginWithFirebase(email, password) {
    try {
        const { auth, signInWithEmailAndPassword } = await initializeFirebase();
        const userCredential = await signInWithEmailAndPassword(auth, email, password);
        const user = userCredential.user;
        
        console.log('✅ Firebase 로그인 성공:', user.email);
        
        // 세션 토큰 저장
        const token = await user.getIdToken();
        return {
            success: true,
            user: {
                email: user.email,
                uid: user.uid,
                token: token
            }
        };
    } catch (error) {
        console.error('❌ Firebase 로그인 실패:', error);
        return {
            success: false,
            error: error.message
        };
    }
}

// 로그아웃 함수
export async function logoutFromFirebase() {
    try {
        const { auth, signOut } = await initializeFirebase();
        await signOut(auth);
        console.log('✅ Firebase 로그아웃 완료');
        return { success: true };
    } catch (error) {
        console.error('❌ Firebase 로그아웃 실패:', error);
        return { success: false, error: error.message };
    }
}

// 인증 상태 확인
export async function checkAuthState() {
    try {
        const { auth, onAuthStateChanged } = await initializeFirebase();
        
        return new Promise((resolve) => {
            onAuthStateChanged(auth, (user) => {
                if (user) {
                    console.log('✅ 사용자 인증됨:', user.email);
                    resolve({
                        authenticated: true,
                        user: {
                            email: user.email,
                            uid: user.uid
                        }
                    });
                } else {
                    console.log('❌ 사용자 인증 안 됨');
                    resolve({ authenticated: false });
                }
            });
        });
    } catch (error) {
        console.error('❌ 인증 상태 확인 실패:', error);
        return { authenticated: false, error: error.message };
    }
}
