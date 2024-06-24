<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SNS 메인 페이지</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to right, #a8e6cf, #dcedc1);
            margin: 0;
            padding: 20px 10px;
        }
        .container {
            max-width: 800px;
            margin: auto;
            background-color: white;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 12px;
            overflow: hidden;
            padding: 20px;
        }
        .post-container {
            margin-bottom: 20px;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 8px;
        }
        .post {
            border-bottom: 1px solid #e9ebee;
            padding: 10px 0;
        }
        .post:last-child {
            border-bottom: none;
        }
        .post-title, .comment-content {
            font-size: 16px;
            font-weight: bold;
            color: #4CAF50;
        }
        .post-content, .comment-text {
            margin: 10px 0;
            color: #333;
        }
        .btn {
            background: none;
            border: none;
            cursor: pointer;
            color: #5fa477;
            font-size: 14px;
            transition: color 0.3s;
            margin-right: 10px;
        }
        .btn:hover {
            color: #588971ac;
        }
        .hidden {
            display: none;
        }
        .follow-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #e9ebee;
        }
        .follow-item:last-child {
            border-bottom: none;
        }
        .username {
            font-size: 16px;
            font-weight: bold;
            color: #4CAF50;
        }
        .unfollow-btn {
            background: none;
            border: none;
            cursor: pointer;
            color: #5fa477;
            font-size: 14px;
            transition: color 0.3s;
        }
        .unfollow-btn:hover {
            color: #588971ac;
        }
        #noFollowers {
            text-align: center;
            color: #4CAF50;
            font-size: 18px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>사용자</h2>
        <div id="other-posts">
            <!-- 사용자1 -->
            <div class="post-container">
                <div class="post" id="post-1">
                    <div class="post-title">사용자1</div>
                    <div class="post-content">다른 사람의 내용 1</div>
                    <button class="btn comment-btn" onclick="showCommentBox(1)">댓글 쓰기</button>
                    <button class="btn follow-btn" onclick="toggleFollow(1)">팔로우</button>
                    <div id="comment-box-1" class="comment-box hidden">
                        <textarea id="comment-text-1" class="comment-text" rows="2" placeholder="댓글 입력"></textarea>
                        <button class="btn add-comment-btn" onclick="addComment(1)">댓글 업로드</button>
                    </div>
                    <div id="comments-1" class="comments"></div>
                </div>
            </div>
            
            <!-- 사용자2 -->
            <div class="post-container">
                <div class="post" id="post-2">
                    <div class="post-title">사용자2</div>
                    <div class="post-content">다른 사람의 내용 2</div>
                    <button class="btn comment-btn" onclick="showCommentBox(2)">댓글 쓰기</button>
                    <button class="btn follow-btn" onclick="toggleFollow(2)">팔로우</button>
                    <div id="comment-box-2" class="comment-box hidden">
                        <textarea id="comment-text-2" class="comment-text" rows="2" placeholder="댓글 입력"></textarea>
                        <button class="btn add-comment-btn" onclick="addComment(2)">댓글 업로드</button>
                    </div>
                    <div id="comments-2" class="comments"></div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // 초기 데이터
        <%--
        JSP에서 Java 코드를 사용하기 위해 Scriptlet 태그 안에 넣습니다.
        --%>
        <%@ page import="java.util.List" %>
        <%@ page import="java.util.ArrayList" %>

        <%--
        초기 데이터 설정
        --%>
        <% List<OtherPost> otherPosts = new ArrayList<>(); %>
        <% otherPosts.add(new OtherPost(1, "사용자1", "다른 사람의 내용 1", new ArrayList<Comment>() {{
                add(new Comment(1, "사용자1의 댓글 예시 1"));
                add(new Comment(2, "사용자1의 댓글 예시 2"));
            }}, false)); %>
        <% otherPosts.add(new OtherPost(2, "사용자2", "다른 사람의 내용 2", new ArrayList<Comment>() {{
                add(new Comment(1, "사용자2의 댓글 예시 1"));
            }}, false)); %>

        <%-- 페이지 로드 시 초기 댓글 렌더링 --%>
        window.onload = function() {
            renderPosts();
        };

        <%-- 포스트 렌더링 함수 --%>
        function renderPosts() {
            const container = document.getElementById('other-posts');
            container.innerHTML = '';

            <% for (OtherPost post : otherPosts) { %>
                const postContainer = document.createElement('div');
                postContainer.className = 'post-container';

                const postDiv = document.createElement('div');
                postDiv.className = 'post';
                postDiv.innerHTML = `
                    <div class="post-title"><%= post.getTitle() %></div>
                    <div class="post-content"><%= post.getContent() %></div>
                    <button class="btn comment-btn" onclick="showCommentBox(<%= post.getId() %>)">댓글 쓰기</button>
                    <button class="btn follow-btn" onclick="toggleFollow(<%= post.getId() %>)"><%= post.isFollowed() ? '팔로우 취소' : '팔로우' %></button>
                    <div id="comment-box-${post.getId()}" class="comment-box hidden">
                        <textarea id="comment-text-${post.getId()}" class="comment-text" rows="2" placeholder="댓글 입력"></textarea>
                        <button class="btn add-comment-btn" onclick="addComment(<%= post.getId() %>)">댓글 업로드</button>
                    </div>
                    <div id="comments-${post.getId()}" class="comments"></div>
                `;
                postContainer.appendChild(postDiv);
                container.appendChild(postContainer);

                // 댓글 렌더링
                renderComments(<%= post.getId() %>, [
                    <% for (Comment comment : post.getComments()) { %>
                        { id: <%= comment.getId() %>, content: "<%= comment.getContent() %>" },
                    <% } %>
                ]);
            <% } %>
        }

        <%-- 댓글 렌더링 함수 --%>
        function renderComments(postId, comments) {
            const commentsContainer = document.getElementById(`comments-${postId}`);
            commentsContainer.innerHTML = '';

            comments.forEach(comment => {
                const commentDiv = document.createElement('div');
                commentDiv.className = 'comment';
                commentDiv.innerHTML = `
                    <div class="comment-content">${comment.content}</div>
                    <button class="btn delete-comment-btn" onclick="deleteComment(${postId}, ${comment.id})">삭제</button>
                `;
                commentsContainer.appendChild(commentDiv);
            });
        }

        <%-- 팔로우 토글 함수 --%>
        function toggleFollow(postId) {
            const post = otherPosts.find(post => post.id === postId);
            post.isFollowed = !post.isFollowed;

            // 팔로우한 경우 사용자 이름을 팔로우 리스트 맨 앞에 추가
            if (post.isFollowed) {
                const username = post.title; // post.title은 사용자 이름 (예: "사용자1", "사용자2")
                followList.unshift(username); // 배열의 맨 앞에 추가
            }

            renderPosts();
        }

        <%-- 댓글 추가 함수 --%>
        function addComment(postId) {
            const textArea = document.getElementById(`comment-text-${postId}`);
            const commentText = textArea.value.trim();
            if (commentText === '') return;

            <%-- JSP에서 Java 코드를 사용하여 댓글 추가 --%>
            const newComment = { id: <%= System.currentTimeMillis() %>, content: commentText };
            const post = otherPosts.find(post => post.id === postId);
            post.comments.push(newComment);

            textArea.value = '';
            renderComments(postId, post.comments);
        }

        <%-- 댓글 삭제 함수 --%>
        function deleteComment(postId, commentId) {
            const post = otherPosts.find(post => post.id === postId);
            post.comments = post.comments.filter(comment => comment.id !== commentId);
            renderComments(postId, post.comments);
        }

    </script>
</body>
</html>
